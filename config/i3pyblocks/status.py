#!/usr/bin/env python3

import asyncio
import logging
import signal
from pathlib import Path

import psutil
import aiofiles

from i3pyblocks import Runner, types, utils, blocks
from i3pyblocks.blocks import (  # shell,
    datetime,
    dbus,
    http,
    i3ipc,
    # inotify,
    ps,
    pulse,
    x11,
)


class PowerBlock(blocks.PollingBlock):
    def __init__(
        self,
        sleep: int = 30,
        battery = "BAT0",
        **kwargs,
    ) -> None:
        super().__init__(sleep=sleep, **kwargs)
        self.path = Path('/sys/class/power_supply/') / battery

    def battery_exists(self) -> bool:
        return self.path.is_dir()

    async def click_handler(self, **_kwargs) -> None:
        await self.run()

    async def run(self) -> None:
        async with aiofiles.open(self.path / 'power_now', 'rt') as f:
            power_now = await f.read()

        power_W = float(power_now.strip()) / 1e6

        self.update(f"󱐋 {power_W :.1f} W")

# Configure logging, so we can have debug information available in
# ~/.i3pyblocks.log
# Use `logging.INFO` to reduce verbosity
logging.basicConfig(filename=Path.home() / ".i3pyblocks.log", level=logging.DEBUG)


# Helper to find partitions, filtering some that we don't want to show
# Will be used later on the DiskUsageBlock
def partitions(excludes=("/boot", "/nix/store")):
    partitions = psutil.disk_partitions()
    return [p for p in partitions if p.mountpoint not in excludes]


async def main():
    # Create a Runner instance, so we can register the modules
    runner = Runner()
    # Show the current network speed for either en* (ethernet) or wl* devices
    await runner.register_block(
        ps.NetworkSpeedBlock(
            format_up=" {interface:.2s}:  {upload}  {download}",
            format_down="",
            interface_regex="en*|wl*",
        )
    )

    power_block = PowerBlock()
    if power_block.battery_exists():
        await runner.register_block(power_block)



    await runner.register_block(ps.VirtualMemoryBlock(format=" {available:.1f}GiB"))

    # Using custom icons to show the temperature visually
    # So when the temperature is above 75,  is shown, when it is above 50,
    #  is shown, etc
    # Needs Font Awesome 5 installed
    await runner.register_block(
        ps.SensorsTemperaturesBlock(
            format="{icon} {current:.0f}°C",
            icons={
                0: "",
                25: "",
                50: "",
                75: "",
            },
        )
    )

    await runner.register_block(
        ps.CpuPercentBlock(format=" {percent}%"),
    )

    # Load only makes sense depending of the number of CPUs installed in
    # machine, so get the number of CPUs here and calculate the color mapping
    # dynamically
    cpu_count = psutil.cpu_count()
    await runner.register_block(
        ps.LoadAvgBlock(
            format=" {load1:0.2f}",
            colors={
                0: types.Color.NEUTRAL,
                cpu_count / 2: types.Color.WARN,
                cpu_count: types.Color.URGENT,
            },
        ),
    )

    await runner.register_block(
        ps.SensorsBatteryBlock(
            format_plugged=" {percent:.0f}%",
            format_unplugged="{icon} {percent:.0f}% {remaining_time}",
            format_unknown="{icon} {percent:.0f}%",
            icons={
                0: "",
                10: "",
                25: "",
                50: "",
                75: "",
            },
        )
    )

    # ToggleBlock works by running the command specified in `command_state`,
    # if it returns any text it will show `format_on`, otherwise `format_off`
    # is shown
    # When `format_on` is being shown, clicking on it runs `command_off`,
    # while when `format_off` is being shown, clicking on it runs `command_on`
    # We are using it below to simulate the popular Caffeine extension in
    # Gnome and macOS
    # await runner.register_block(
    #     shell.ToggleBlock(
    #         command_state="xset q | grep -Fo 'DPMS is Enabled'",
    #         command_on="xset s on +dpms",
    #         command_off="xset s off -dpms",
    #         format_on="  ",
    #         format_off="  ",
    #     )
    # )

    # This is equivalent to the example above, but using pure Python
    # await runner.register_block(
    #     x11.CaffeineBlock(
    #         format_on="  ",
    #         format_off="  ",
    #     )
    # )

    # KbddBlock uses D-Bus to get the keyboard layout information updates, so
    # it is very efficient (i.e.: there is no polling). But it needs `kbdd`
    # installed and running: https://github.com/qnikst/kbdd
    # Using mouse buttons or scroll here allows you to cycle between the layouts
    # By default the resulting string is very big (i.e.: 'English (US, intl.)'),
    # so we lowercase it using '!l' and truncate it to the first two letters
    # using ':.2s', resulting in `en`
    # You could also use '!u' to UPPERCASE it instead
    # await runner.register_block(
    #     dbus.KbddBlock(
    #         format=" {full_layout!l:.2s}",
    #     )
    # )

    # MediaPlayerBlock listen for updates in your player (in this case Spotify)
    #await runner.register_block(dbus.MediaPlayerBlock(player="spotify"))

    # In case of `kbdd` isn't available for you, here is a alternative using
    # ShellBlock and `xkblayout-state` program.  ShellBlock just show the output
    # of `command` (if it is empty this block is hidden)
    # `command_on_click` runs some command when the mouse click is captured,
    # in this case when the user scrolls up or down
    # await runner.register_block(
    #     shell.ShellBlock(
    #         command="xkblayout-state print %s",
    #         format=" {output}",
    #         command_on_click={
    #             types.MouseButton.SCROLL_UP: "xkblayout-state set +1",
    #             types.MouseButton.SCROLL_DOWN: "xkblayout-state set -1",
    #         },
    #     )
    # )

    # By default BacklightBlock showns a message "No backlight found" when
    # there is no backlight
    # We set to empty instead, so when no backlight is available (i.e.
    # desktop), we hide this block
    # await runner.register_block(
    #     inotify.BacklightBlock(
    #         format=" {percent:.0f}%",
    #         format_no_backlight="",
    #         command_on_click={
    #             types.MouseButton.SCROLL_UP: "brightnessctl s +5%",
    #             types.MouseButton.SCROLL_DOWN: "brightnessctl s -5%",
    #         },
    #     )
    # )

    # `signals` allows us to send multiple signals that this block will
    # listen and do something
    # In this case, we can force update the module when the volume changes,
    # for example, by running:
    # $ pactl set-sink-volume @DEFAULT_SINK@ +5% && pkill -SIGUSR1 example.py
    await runner.register_block(
        pulse.PulseAudioBlock(
            format=" {volume:.0f}%",
            format_mute=" mute",
        ),
        signals=(signal.SIGUSR1, signal.SIGUSR2),
    )

    # RequestsBlock do a HTTP request to an url. We are using it here to show
    # the current weather for location, using
    # https://github.com/chubin/wttr.in#one-line-output
    # For more complex requests, we can also pass a custom async function
    # `response_callback`, that receives the response of the HTTP request and
    # you can manipulate it the way you want
    # await runner.register_block(
    #     http.PollingRequestBlock(
    #         "https://wttr.in/?format=%c+%t",
    #         format_error="",
    #         sleep=60 * 60,
    #     ),
    # )

    # You can use Pango markup for more control over text formating, as the
    # example below shows
    # For a description of how you can customize, look:
    # https://developer.gnome.org/pango/stable/pango-Markup.html
    await runner.register_block(
        datetime.DateTimeBlock(
            format_time=utils.pango_markup(" %T", font_weight="bold"),
            format_date=utils.pango_markup(" %a, %d/%m", font_weight="light"),
            default_state={"markup": types.MarkupText.PANGO},
        )
    )

    # Start the Runner instance
    await runner.start()


if __name__ == "__main__":
    # Start the i3pyblocks
    asyncio.run(main())

