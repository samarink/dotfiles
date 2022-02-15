# ZSH Init{{{

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME=powerlevel10k/powerlevel10k

# Plugins
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    vi-mode
)

# load plugins
source $ZSH/oh-my-zsh.sh
#}}}

# Tweaks And Settings {{{

# Aliases
if [ -f ~/.config/aliasrc ]; then
. ~/.config/aliasrc
fi

# History in cache directory:

# create a history file if it does not exist already
if [[ ! -e ~/.cache/zsh ]]; then
    mkdir -p ~/.cache/zsh
    touch ~/.cache/zsh/history
fi

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# accept history completion suggestion
bindkey '^j' autosuggest-accept

# mkdir and cd into it
mcd () {
    mkdir -p -- "$1" &&
      cd -P -- "$1"
}

# colored man
man() {
    LESS_TERMCAP_md=$'\e[0;34m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[00;35m' \
    command man "$@"
}
#}}}

# Exports, evals etc. {{{

# add brew to path
export PATH=/opt/homebrew/bin:$PATH

# add bin to path for user scripts
export PATH="$PATH:$HOME/.local/bin"

# allow global package installation
export PATH=~/.npm-global/bin:$PATH

# enable fasd for easy directory switching
eval "$(fasd --init auto)"

# fzf default command for vim
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --iglob **/node_modules'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#}}}
