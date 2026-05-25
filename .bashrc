#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1="\[\e[1;32m\]\u\[\e[m\]\[\e[1;37m\]@\[\e[m\]\[\e[1;32m\]\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;33m\]\$\[\e[m\] "

# set vim as global editor
export VISUAL=nvim
export EDITOR="$VISUAL"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LS_COLORS="*.go=00;36:*.py=00;33:*.sql=1;36:ow=01;34:"

alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# ---------------------------- Path stuff ----------------------------

# Golang
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# Mason
export PATH=$PATH:$HOME/.local/share/nvim/mason/bin

# Turso
export PATH="$PATH:/home/sven/.turso"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/sven/google-cloud-sdk/path.bash.inc' ]; then . '/home/sven/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/sven/google-cloud-sdk/completion.bash.inc' ]; then . '/home/sven/google-cloud-sdk/completion.bash.inc'; fi

# --------------------------- Pyenv stuff ---------------------------
#
pyenv_activate() {
    bname=${PWD##*/}
    pyenv activate "$bname"
    echo "venv: ${bname}"
}
alias pyenv-activate=pyenv_activate

pyenv_make() {
    local python_version

    # look for file version
    if [[ -f .python-version ]]; then
        python_version="$(head -n 1 .python-version)"
    # look for local version
    elif
        python_version="$(pyenv local 2>/dev/null | head -n 1)"
        [[ -n "$python_version" ]]
    then
        :
    # default to global
    elif
        python_version="$(pyenv global 2>/dev/null | head -n 1)"
        [[ -n "$python_version" ]]
    then
        :
    else
        echo "Error: Could not determine Python version (.python-version, pyenv local, or pyenv global not found)." >&2
        return 1
    fi

    echo "Using Python $python_version to create virtualenv: ${PWD##*/}"
    pyenv virtualenv "$python_version" "${PWD##*/}" || return 1
    pyenv activate "${PWD##*/}" || return 1
}

alias pyenv-make=pyenv_make

# QC Compiler
export QC_STDLIB="/usr/share/qc"

# Env Vars
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

alias loadenv='set -a; source .env; set +a'

# opencode
export PATH=/home/sven/.opencode/bin:$PATH
