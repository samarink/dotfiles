#!/bin/sh

# set up dual monitor
xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 0x0 \
       --output VGA-0 --mode 1280x1024 --pos 1920x0 --right-of HDMI-0

# wallpaper
feh --bg-scale ~/.config/wallpaper.png &

# compositor (tryone fork)
compton --blur-background --blur-method kawase --blur-strength 9 \
  --opacity-rule 85:'class_g="kitty"' --backend glx -b \
  --config ~/.config/compton/compton.conf

# keyboard layout
setxkbmap -model pc104 -layout us,ru -variant ,, -option caps:swapescape -option grp:win_space_toggle -option altwin:menu_win

xset r rate 300 50 # speed up keyboard rate
slstatus&          # statusline for dwm
imwheel -f &       # mouse scroll speed fix
redshift&          # auto ajust monitor color temp
flameshot&         # screenshot tool
copyq&             # clipboard manager
dunst&             # notifications daemon
thunar --daemon&   # file manager, fix startup delay
updates-notify&    # run updates notifier script
