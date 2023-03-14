#!/usr/bin/env bash

chosen=$(printf "\n⏻\n  Suspend\n  Log Out\n" | rofi -dmenu -i -theme-str '@import "/home/jhivens/.config/rofi/dropdown.rasi"')

case "$chosen" in
	"") /home/jhivens/.config/hypr/scripts/bluetooth.sh;;
	"  Restart")  ;;
	"  Suspend")  ;;
	"  Log Out") ;;
	"⏻") /home/jhivens/.config/hypr/scripts/powermenu.sh;;
	*) exit 1 ;;
esac

