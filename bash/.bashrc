# ~/.bashrc: Ejecutado por bash(1) para shells interactivos.

case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%d/%m/%y %T "

shopt -s checkwinsize
shopt -s cdspell

force_color_prompt=yes

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/\* \(.*\)/ (\1)/'
}


if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        RESET="\[\033[0m\]"
        GREEN="\[\033[01;32m\]"
        BLUE="\[\033[01;34m\]"
        YELLOW="\[\033[01;33m\]"
        RED="\[\033[01;31m\]"
        
        
        set_prompt() {
            if [ $? -eq 0 ]; then PROMPT_SYMBOL="${GREEN}\$${RESET}"; else PROMPT_SYMBOL="${RED}\$${RESET}"; fi
            PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}${YELLOW}\$(parse_git_branch)${RESET} ${PROMPT_SYMBOL} "
        }
        PROMPT_COMMAND=set_prompt
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR='vim'

alias reload='source ~/.bashrc && echo "Bash recargado."'
alias update='sudo apt update && sudo apt upgrade'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias ta='tmux a'
alias tls='tmux ls'

alias gccw='gcc -Wall -Wextra -pedantic'
alias val='valgrind --leak-check=full --track-origins=yes'

alias pip='pip3'
alias python='python3'
alias pm='python3 manage.py'
alias rundj='python3 manage.py runserver'
alias shell='python3 manage.py shell_plus || python3 manage.py shell'

djmig() {
    echo "Creando migraciones"
    python3 manage.py makemigrations && \
    echo "Aplicando migraciones..." \
    python3 manage.py migrate
    echo "ok"
}

mkcd() {
    mkdir -p "$1"
    cd "$1"
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
