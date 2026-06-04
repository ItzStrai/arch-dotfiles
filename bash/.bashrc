#
# ~/.bashrc
#

[[ $- != *i* ]] && return
[ ! -t 0 ] && set +m

export TERMINAL='/usr/bin/kitty'
export EDITOR='/usr/bin/nvim'
# If not running interactively, don't do anything

case "$TERM" in
  xterm-color|*-256color|xterm-kitty|linux) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# useful information for some tools
alias yay='yay --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias rsync='rsync --info=progress'

# shortcuts
alias la='ls -A'
alias ff='fastfetch'

alias pingg='ping google.com'
alias kitty-detach='kitty --detach'
alias yaycc='sudo rm -rv /var/cache/pacman/pkg/download-*'

alias viniri='$EDITOR ~/.dotfiles/niri/.config/niri/config.kdl'
alias vibashrc='$EDITOR ~/.bashrc'

alias profile-boost='sudo auto-cpufreq --force performance'
alias profile-power='sudo auto-cpufreq --force powersave'
alias profile='sudo auto-cpufreq --force reset'

alias conda='source .venv/bin/activate'

# export some dirs into PATH
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

