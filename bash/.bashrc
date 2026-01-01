# ~/.bashrc: Ejecutado por bash(1) para shells interactivos.

case $- in
    *i*) ;;
      *) return;;
esac

# --- HISTORIAL ---
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%d/%m/%y %T "

# --- OPCIONES DE SHELL ---
shopt -s checkwinsize
shopt -s cdspell

force_color_prompt=yes

# --- CONFIGURACIÓN PRO DEL PROMPT (Git + Venv) ---

# 1. Función para obtener la rama de Git
parse_git_branch() {
     git symbolic-ref --short HEAD 2> /dev/null | sed 's/^/ (/' | sed 's/$/)/'
}

# 2. Función para detectar Virtual Environment (Python)
parse_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "($(basename "$VIRTUAL_ENV")) "
    fi
}

# 3. Colores ANSI
c_green="\[\033[0;32m\]"    # Usuario
c_blue="\[\033[0;34m\]"     # Carpeta
c_yellow="\[\033[1;33m\]"   # Git
c_purple="\[\033[1;35m\]"   # Venv
c_red="\[\033[0;31m\]"      # Error
c_reset="\[\033[0m\]"

# 4. Función constructora del Prompt
set_prompt() {
    last_cmd=$?
    
    if [ $last_cmd -eq 0 ]; then
        symbol="${c_green}\$${c_reset}"
    else
        symbol="${c_red}\$${c_reset}"
    fi

    # ARQUITECTURA: [Venv] Usuario@Host : Carpeta (Rama) $
    PS1="${c_purple}\$(parse_venv)${c_green}\u@\h${c_reset}:${c_blue}\w${c_yellow}\$(parse_git_branch)${c_reset} ${symbol} "
}

PROMPT_COMMAND=set_prompt

# Evitar duplicados de venv
export VIRTUAL_ENV_DISABLE_PROMPT=1

# --- TÍTULO DE VENTANA ---
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# --- COLORES LS ---
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colores para GCC (C)
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# --- ALIAS ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Paths
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR='vim'

# Utilidades
alias reload='source ~/.bashrc && echo "Bash recargado."'
alias update='sudo apt update && sudo apt upgrade'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Tmux
alias ta='tmux a'
alias tls='tmux ls'

# C Dev
alias gccw='gcc -Wall -Wextra -pedantic'
alias val='valgrind --leak-check=full --track-origins=yes'

# Python / Django
alias pip='pip3'
alias python='python3'
alias pm='python3 manage.py'
alias rundj='python3 manage.py runserver'
alias shell='python3 manage.py shell_plus || python3 manage.py shell'

# Función corregida (agregado &&)
djmig() {
    echo "Creando migraciones..."
    python3 manage.py makemigrations && \
    echo "Aplicando migraciones..." && \
    python3 manage.py migrate
    echo "ok"
}

mkcd() {
    mkdir -p "$1"
    cd "$1"
}

# --- CARGAS EXTERNAS ---
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
