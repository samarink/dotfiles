# expand path
export PATH="$PATH:$HOME/.local/bin"

# default programs
export EDITOR="nvim"
export TERMINAL="kitty"
export READER="zathura"

# xdg specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# autostart script (programs and stuff)
~/.config/autostart.sh

# window manager
exec dwm
