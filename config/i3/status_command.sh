#!/bin/sh


if [ -d ~/.venv/i3pyblocks ]; then
    ~/.venv/i3pyblocks/bin/python3 ~/.config/i3pyblocks/status.py
else
    i3status --color always
fi

