#!/bin/bash

max_brightness=$(cat /sys/class/leds/asus::kbd_backlight/max_brightness)
brightness=$(cat /sys/class/leds/asus::kbd_backlight/brightness)

if [[ $brightness < $max_brightness ]]; then
    let $brightness=$brightness-1
    echo "echo $brightness > /sys/class/leds/asus::kbd_backlight/brightness" | sudo zsh
fi
