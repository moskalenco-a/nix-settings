# .bashrc

# Loading base config
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Node Version Manager
# (code was added automatically)
# Load nvm & load nvm bash_completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="~/.local/bin:$PATH"

# flyctl => fly.io
export FLYCTL_INSTALL="/home/andrey/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# PS1="\w\n$ "                           # custom prompt = "full path\n"
PS1="[\u@\H \W]$ "                       # custom prompt = "[user@host dir]$ "

# .inputrc
bind 'set bell-style none'               # disable bell
bind 'set completion-ignore-case on'     # ignore case for completion

# Show date / time in history
HISTTIMEFORMAT="%Y-%m-%d %T "

# Use Vim as default editor
export EDITOR="vimx"

# Aliases for basic commands
alias wh="which"                         # which
alias cls="clear"                        # clear screen
alias nf="neofetch"                      # neofetch
alias up="uptime -p"                     # show uptime(hours, minutes)
alias ls="ls --color --g"                # color ls with --group-directories-first
alias ll="ls -lA"                        # show all files, one file per row
alias lsa="ls -A"                        # show all files
alias du="du -sh"                        # disk usage: summary + human readable
alias cpr="cp -r"                        # copy directory
alias mkdir="mkdir -p"                   # create nested directories
alias nau="nautilus . &"                 # open Nautilus in current dir
alias vim="vimx"                         # use vim with clipboard support
alias reload-bashrc="source ~/.bashrc"   # reload .bashrc
alias mr="make && make run"              # make + run
alias cmr="clear && make && make run"    # clear + make + run

# Aliases for update
# Fedora
function dnfup {
    echo "sudo dnf update --refresh"
    sudo dnf update --refresh
}

# Flatpak
function flatup {
    echo "flatpak update"
    flatpak update
}

# Aliases for git commands
alias gits="git status"
alias gita="git add"
alias gitc="git commit"
alias gitp="git push"

# Own aliases for cd
alias ..="cd .."
alias ...="cd ../.."
alias cd-music="cd ~/Music"
alias cd-dotfiles="cd ~/dotfiles/"
alias cd-downloads="cd ~/Downloads"
alias cd-telegram-downloads="cd ~/Downloads/Telegram\ Desktop"
alias cd-test-dir="cd ~/TestingDir/"
alias cd-projects="cd ~/Projects"
alias cd-labs="cd ~/Labs"
alias cd-notes="cd ~/Notes"
alias cd-notes-private="cd ~/NotesPrivate"
alias cd-books="cd ~/Books/"
alias cd-books-new="cd ~/BooksNew/"
alias cd-giftbox="cd ~/Projects/Giftbox"
alias cd-giftbox-client="cd ~/Projects/Giftbox/ClientApp/src"
alias cd-react-fractal="cd ~/Projects/react-fractal"

# Aliases for opening configs
alias opxterm="$EDITOR ~/XTerm"
alias opnautiterm="$EDITOR ~/.config/nautiterm.yml"
alias opvimrc="$EDITOR ~/.vimrc"
alias opbashrc="$EDITOR ~/.bashrc"
alias optmux="$EDITOR ~/.tmux.conf"
alias opgitignore="$EDITOR ~/.gitignore"
alias opzathurarc="$EDITOR ~/.config/zathura/zathurarc"

# Find process by name
function ps-find {
    ps -aux | grep $1
}

# Create directory and go there or
# Create yyyy-mm-dd directory (if no params)
function mkcd {
    newdir=$(date '+%Y-%m-%d')
    if [ $# -eq 0 ]
    then
        mkdir -p "${newdir}" && cd "${newdir}"
    else
        mkdir -p -- "$1" && cd -P -- "$1"
    fi
}

# Go to dir with name yyyy-mm-dd
function cd-date {
    cd "$(date '+%Y-%m-%d')"
}

# Print first line of --version
function ver {
    $1 --version | head -1
}

# Add directory to zip
function zip-dir {
    file="$1"
    [[ "${file}" == */ ]] && file="${file: : -1}"
    zip -r "${file}.zip" "${file}"
}

# Copy file path to clipboard
function cp-path {
    (echo -n "file://$(realpath $1)/") | xclip -sel clip
}

# Copy file to clipboard
function cp-file {
    echo "file://$(readlink -f $1)" | xclip -sel clip -t text/uri-list
}

# Copy file to clipboard
# function cp-file {
#     echo "file://$(readlink -f $1)" | wl-copy --type text/uri-list
# }

# Create file with template
function new-file {
    case "$1" in
        *.c) cp ~/Templates/C/main.c "$1" ;;
        *.cpp) cp ~/Templates/C++/main.cpp "$1" ;;
        *.pas) cp ~/Templates/Free_Pascal/program.pas "$1" ;;
        *.js) cp ~/Templates/JavaScript/index.js "$1" ;;
        *.py) cp ~/Templates/Python/main.py "$1" ;;
        *) echo "Unknown project type" ;;
    esac
}

# Create project (directory) with template
function new-project {
    if [[ "$1" == "c" ]]
    then
        cp -r ~/Templates/C/ "$2"
    elif [[ "$1" == "cpp" ]]
    then
        cp -r ~/Templates/C++/ "$2"
    elif [[ "$1" == "fpc" ]]
    then
        cp -r ~/Templates/Free_Pascal "$2"
    elif [[ "$1" == "java" ]]
    then
        cp -r ~/Templates/Java/ "$2"
    elif [[ "$1" == "winapi" ]]
    then
        cp -r ~/Templates/WinAPI "$2"
    else
        echo "Unknown project type"
    fi
}

# Run one-file project
function run {
    file=$1
    out="${file%.*}"
    # out=$(date +'%Y%m%d%H%M%S')
    flags="-Wall -Wextra"
    rem=""
    case "$1" in
        *.c)
            cmd="gcc ${flags} -std=c11 ${file} -o ${out} -lm && ./${out}"
            rem="rm ${out}"
            ;;
        *.cpp)
            cmd="g++ ${flags} -std=c++17 ${file} -o ${out} -lm && ./${out}"
            rem="rm ${out}"
            ;;
        *.pas)
            cmd="fpc -l- -v0 ${file} && ./${out}"
            rem="rm ${out} *.o"
            ;;
        *.js) cmd="node $1" ;;
        *.py) cmd="python $1" ;;
        *.java)
            cmd="javac ${file}" ;;
        *) echo "Unknown project type" ;;
    esac
    echo $cmd
    eval "${cmd};${rem}"
}

# Clear screen and
# run one-file project
function cr {
    clear && run $1
}

# cd && clear && echo 'My tmux sessions' && ls -1 *.sh
