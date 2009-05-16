# ~/.zshrc - aym3ric-at-goto10-dot-org
# http://320x200.goto10.org - http://goto10.org
# a nice and simple zshrc :)

# LOCALE settings ---------------------------------------------------
export LANG=en_US # Some apps do not like the default C

# theme -------------------------------------------------------------
# prompt
PS1=$'%{\e[1;36m%}(%{\e[34m%}%30<..<%~%{\e[36m%}) %{\e[36m%}%#%b 
%{\e[0m%}'
if [ "`id -u`" -eq 0 ]; then
export RPS1=$'%{\e[37m%}%{\e[1;30m%}%{\e[7m%} %M %{\e[0m%}'
else
export RPS1=$'%{\e[37m%}%{\e[1;30m%} %M %{\e[0m%}'
fi

zstyle ':completion:*' menu select=1  # completion menu
#eval "`dircolors -b /etc/DIR_COLORS`" # simple system-wide dircolors

# completion --------------------------------------------------------
# ssh host completion
[ -f ~/.ssh/config ] && : 
${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host 
*}#Host }:#*\**}:#*\?*}}
[ -f ~/.ssh/known_hosts ] && : 
${(A)ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}
zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts

unsetopt list_ambiguous         # prompt after 1st tab
setopt glob_dots                # completion for dot files

# keybinding --------------------------------------------------------
# special keys for console and xterm
if [[ $TERM = "linux" || $TERM = "screen" ]];then
    bindkey "^[[2~" 	overwrite-mode
    bindkey "^[[3~" 	delete-char
    bindkey "^[[5~" 	up-line-or-history
    bindkey "^[[6~" 	down-line-or-history
    bindkey "^[[1~" 	beginning-of-line
    bindkey "^[[4~" 	end-of-line
    bindkey "^[e" 	expand-cmd-path
elif [[ $TERM = "xterm" || $TERM = "xterm-color" ]];then
    bindkey "^[[2~" 	overwrite-mode
    bindkey "^[[3~" 	delete-char
    bindkey "^[[5~" 	up-line-or-history
    bindkey "^[[6~" 	down-line-or-history
    bindkey "^[[H" 	beginning-of-line
    bindkey "^[[F" 	end-of-line
    bindkey "^[e" 	expand-cmd-path
fi

# bells -------------------------------------------------------------
# unsetopt beep		# no beep
unsetopt hist_beep	# no beep
unsetopt list_beep	# no beep

# aliases -----------------------------------------------------------
# ls stuff
alias ls='ls --classify --color=auto --human-readable'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lsa='ls -ld .*'
alias lsd='ls -ld *(-/DN)'
# handy 
alias df='df --human-readable'
alias du='du --human-readable'

# various -----------------------------------------------------------
unsetopt ignore_eof 	# Ctrl+D acts like a 'logout'
setopt print_exit_value # print exit code if different from '0'
unsetopt rm_star_silent # confirmation asked for 'rm *'

# buddies -----------------------------------------------------------
watch=(notme)                   	# watch for everybody but me
LOGCHECK=300                    	# check activity every 5 min
WATCHFMT='%n %a %l from %m at %t.'	# watch display

# history -----------------------------------------------------------
export HISTORY=600
export SAVEHIST=600
export HISTFILE=$HOME/.history
setopt hist_verify		# prompt before execution

# SuperCollider------------------------------------------------------
#SC_LIB_DIR=/opt/sc/share/SuperCollider/SCClassLibrary
#export SC_JACK_DEFAULT_INPUTS="alsa_pcm:capture_1,alsa_pcm:capture_2" 
#export 
SC_JACK_DEFAULT_OUTPUTS="alsa_pcm:playback_1,alsa_pcm:playback_2"
#export SC_SYNTHDEF_PATH=$HOME/sc/synthdefs

# -------------------------------------------------------------------
autoload -U compinit 
compinit

