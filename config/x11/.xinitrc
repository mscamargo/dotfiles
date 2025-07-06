systemctl --user import-environment DISPLAY XAUTHORITY
dbus-update-activation-environment --all &
gnome-keyring-daemon --start --components=secrets &
statusbarloop &
remaps &
exec dwm
