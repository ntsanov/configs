#!/bin/bash
### wallpaper
WALLPAPER=`cat ~/.config/wallpaper`
if ! [ -z $WALLPAPER ]; then
	feh --bg-scale $WALLPAPER
fi

picom -b

export BROWSER="chromium"

### Ghidra opens as a gray window otherwise
export _JAVA_AWT_WM_NONREPARENTING=1

### Java expects reparenting, setting wm name to LG3D manages to trick it
#wmname LG3D

# Start gnome-keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

/usr/bin/dunst&
### Start blocks as bg process
/usr/local/bin/dwmblocks&
exec /usr/local/bin/dwm
