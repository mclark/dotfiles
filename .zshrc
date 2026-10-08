plugins=(jj)

source $ZSH/oh-my-zsh.sh

# jj recent ancestors shortcut
jjr() { jj log -r "ancestors(@, ${1:-5})"; }
