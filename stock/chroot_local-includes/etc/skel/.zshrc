# ~/.zshrc 
# Puredyne zsh config

# misc
setopt nohup # Don't kill jobs when logout

# theme -------------------------------------------------------------
# prompt
PS1=$'%{\e[1;36m%}(%{\e[34m%}%30<..<%~%{\e[36m%}) %{\e[36m%}%#%b %{\e[0m%}'
if [ "`id -u`" -eq 0 ]; then
export RPS1=$'%{\e[37m%}%{\e[1;30m%}%{\e[7m%} %M %{\e[0m%}'
else
export RPS1=$'%{\e[37m%}%{\e[1;30m%} %M %{\e[0m%}'
fi
# colors
eval `dircolors -b ~/.dircolors`

# completion --------------------------------------------------------
zstyle ':completion:*' menu select=1  # completion menu
# ssh host completion
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
[ -f ~/.ssh/known_hosts ] && : ${(A)ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}
zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts

unsetopt list_ambiguous         # prompt after 1st tab
setopt glob_dots                # completion for dot files

# bells -------------------------------------------------------------
unsetopt beep		# no beep
unsetopt hist_beep	# no beep
unsetopt list_beep	# no beep

# aliases -----------------------------------------------------------
# ls stuff
alias ls='ls --classify --color=auto --human-readable --time-style=locale'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lsa='ls -ld .*'
alias lsd='ls -ld *(-/DN)'
# handy 
alias df='df --human-readable'
alias du='du --human-readable'
alias grep='grep --color'

# various -----------------------------------------------------------
unsetopt ignore_eof 	# Ctrl+D acts like a 'logout'
setopt print_exit_value # print exit code if different from '0'
unsetopt rm_star_silent # confirmation asked for 'rm *'

# buddies -----------------------------------------------------------
watch=(notme)                   	# watch for everybody but me
LOGCHECK=300                    	# check activity every 5 min
WATCHFMT='%n %a %l from %m at %t.'	# watch display

# history -----------------------------------------------------------
export HISTORY=1600
export SAVEHIST=1600
export HISTFILE=$HOME/.history
setopt hist_verify		# prompt before execution


# colorful manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;37m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# -------------------------------------------------------------------
autoload -U compinit 
compinit

# update title bar
function settitle { print -Pn "\e]2;%n@%m: %~\a" }
function chpwd { settitle }
function precmd { settitle }


