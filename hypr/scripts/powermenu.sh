#!/usr/bin/env bash

uptime="`uptime -p | sed -e 's/up //g'`"
id=`loginctl session-status | awk -F ' ' 'NR==1{print $1}'`;

chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Log Out\n  Lock" | rofi -dmenu -i -theme-str '@import "/home/jhivens/.config/rofi/powermenu.rasi"' -mesg "Uptime: $uptime" -p "Power OFF")

case "$chosen" in
	"  Power Off") shutdown now ;;
	"  Restart") reboot ;;
	"  Suspend") systemctl suspend ;;
	"  Log Out") loginctl kill-session $id;;
	"  Lock") $HOME/.config/hypr/scripts/lockscreen ;;
	*) exit 1 ;;
esac

# loginctl terminate-session ${XDG_SESSION_ID-}