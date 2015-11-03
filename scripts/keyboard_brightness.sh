#!/bin/bash

# Add this to sudoers file:
# username ALL=(ALL) NOPASSWD: /path/to/script

max_brightness=$(cat /sys/class/leds/asus::kbd_backlight/max_brightness)

function increase_brightness() {
    brightness=$(cat /sys/class/leds/asus::kbd_backlight/brightness)
    if [[ $brightness -lt $max_brightness ]]; then
        let brightness=$brightness+1
        sudo echo $brightness > /sys/class/leds/asus::kbd_backlight/brightness
    fi
}


function decrease_brightness() {
    brightness=$(cat /sys/class/leds/asus::kbd_backlight/brightness)
    if [[ $brightness -gt 0 ]]; then
        let brightness=$brightness-1
        sudo echo $brightness > /sys/class/leds/asus::kbd_backlight/brightness
    fi
}

if [[ $# -gt 0 ]]; then
    if [[ $1 == "increase" ]]; then
        increase_brightness
    elif [[ $1 == "decrease" ]]; then
        decrease_brightness
    fi
else
    echo "Usage: keyboard_brightness.sh [increase | decrease]"
fi
