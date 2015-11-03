#!/bin/bash

brightness=$(cat /sys/class/leds/asus::kbd_backlight/brightness)
if [[ $brightness > 0 ]]; then
    let brightness=$brightness-1
    echo "echo $brightness > /sys/class/leds/asus::kbd_backlight/brightness" | sudo zsh
fi
