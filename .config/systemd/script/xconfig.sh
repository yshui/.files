#!/bin/sh
xrdb -merge ~/.Xresources
xset m 8/5 3/2
xmodmap ~/.xmodmap
feh --bg-fill ~/.wallpaper
