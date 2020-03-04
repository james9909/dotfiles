#!/bin/bash

. "${HOME}/.cache/wal/colors.sh"

bg="$color0"
border="$color2"
separator="$color2"
fg="$color7"
bgalt="$color0"
urgent="$color9"
fgalt="$color7"
hlbg="$color2"
hlfg="$color0"

rofi -show "drun" -color-window "$bg, $fg, $border" \
                    -color-normal "$bg, $fg, $bgalt, $hlbg, $hlfg" \
                    -color-urgent "$bg, $urgent, $bgalt, $urgent, $fg" \
                    -color-active "$bg, $fg, $bgalt, $hlbg, $hlfg"
