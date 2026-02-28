# --- CONFIGURACIÓN BÁSICA ZSH ---
autoload -Uz compinit && compinit       
setopt autocd                           
setopt interactive_comments             
setopt prompt_subst                     

# --- HISTORIAL ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history       
setopt hist_ignore_all_dups 
setopt share_history       

# --- COLORES Y PROMPT ---
autoload -U colors && colors
autoload -U add-zsh-hook    # IMPORTANTE: Cargamos la herramienta primero

# Función para Git 
parse_git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    [[ -n "$branch" ]] && echo " ($branch)"
}

# Función para Virtual Environment
parse_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "($(basename "$VIRTUAL_ENV")) "
    fi
}

# %n=usuario, %m=host, %~=carpeta, %?=estado último comando
set_prompt() {
    local last_status=$?  # Guardamos el estado inmediatamente
    local symbol="%F{green}\$%f"
    [[ $last_status -ne 0 ]] && symbol="%F{red}\$%f"

    PROMPT="%F{magenta}\$(parse_venv)%f%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}\$(parse_git_branch)%f ${symbol} "
}


add-zsh-hook precmd set_prompt # AHORA SÍ: La usamos
export VIRTUAL_ENV_DISABLE_PROMPT=1

# --- ALIAS ---
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias reload='source ~/.zshrc && echo "Zsh recargado."'
alias update='sudo apt update && sudo apt upgrade'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Python / Django / Dev
alias pip='pip3'
alias python='python3'
alias pm='python3 manage.py'
alias rundj='python3 manage.py runserver'
alias shell='python3 manage.py shell_plus || python3 manage.py shell'
alias gccw='gcc -Wall -Wextra -pedantic'
alias val='valgrind --leak-check=full --track-origins=yes'

# --- FUNCIONES ---
djmig() {
    echo "Creando migraciones..."
    python3 manage.py makemigrations && \
    echo "Aplicando migraciones..." && \
    python3 manage.py migrate
    echo "ok"
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

# --- PATHS Y ENTORNO ---
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:/opt/nvim-linux-x86_64/bin:$PATH"
export EDITOR='vim'

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# --- CORRECCIÓN DE COLORES LS ---
if [[ -x /usr/bin/dircolors ]]; then
    eval "$(dircolors -b)"
fi

# --- CORRECCIÓN DE TECLAS  ---
bindkey  '^[[H'   beginning-of-line
bindkey  '^[[F'   end-of-line
bindkey  '^[[3~'  delete-char
