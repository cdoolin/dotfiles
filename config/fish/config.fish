
if test -d ~/.venv/venv
    source ~/.venv/venv/bin/activate.fish
end

if type -q batcat
    alias bat batcat
end

set -gx LESS "-FRX"

alias tf "tmux-sessionizer"

# prevent systemd clearing tmux sessions on logout
if ps -C systemd > /dev/null
    alias tmux "systemd-run --scope --user tmux"
end

if test -d ~/.cargo/bin
    fish_add_path --path ~/.cargo/bin
end

if test -d ~/bin
    fish_add_path --path ~/bin
end

if type -q starship
    starship init fish | source
end

