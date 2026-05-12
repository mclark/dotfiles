plugins=(git)

source $ZSH/oh-my-zsh.sh

eval "$(/home/codespace/.local/bin/mise activate zsh)"

# jj recent ancestors shortcut
jjr() { jj log -r "ancestors(@, ${1:-5})"; }
