#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias wget="wget -c"
alias htop="btop"
alias ls="eza -l --no-permissions --no-user --no-time --icons --group-directories-first --header"
alias cat='bat -f --style="header,header-filesize,grid,numbers,snip"'
alias grep="ugrep --color=auto -F"

PS1='[\u@\h \W]\$ '

export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init bash)"