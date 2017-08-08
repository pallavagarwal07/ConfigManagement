#!/usr/bin/env bash
while [ "$select" != "NO" -a "$select" != "SHUTDOWN" -a "$select" != "LOGOUT" -a "$select" != "REBOOT" ]; do
    select=$(echo -e 'NO\nSHUTDOWN\nLOGOUT\nREBOOT' | dmenu -nb '#151515' -nf '#999999' -sb '#f0f060' -sf '#000000' -fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*'  -fn 'Source Code Pro' -i -p "You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.")
    [ -z "$select" ] && exit 0
done
[ "$select" = "NO" ] && exit 0
[ "$select" = "LOGOUT" ] && i3-msg exit
[ "$select" = "SHUTDOWN" ] && sudo shutdown -h now
[ "$select" = "REBOOT" ] && sudo reboot
