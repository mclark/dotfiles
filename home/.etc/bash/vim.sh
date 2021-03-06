if [ -d /usr/local/Cellar/macvim ]; then
  macvim_brew_versions=(`ls /usr/local/Cellar/macvim`)
  for latest_macvim_brew_version in "${macvim_brew_versions[@]}"; do :; done
  if [ ! -z "$latest_macvim_brew_version" ]; then
    export VIM_APP_DIR="/usr/local/Cellar/macvim/$latest_macvim_brew_version"
  fi
elif [ -d "/Applications/MacVim.app" ]; then
  export VIM_APP_DIR="/Applications"
fi

if [[ $(command -v nvim) ]]; then
  alias v='nvim'
  alias vim='nvim'
  export EDITOR='nvim'
elif [ ! -z "$VIM_APP_DIR" ] && [ -d $VIM_APP_DIR ]; then
  alias v='mvim'
  alias vim='mvim -v'
  export EDITOR="mvim -vf"
else
  export EDITOR="vim -vf"
fi

function janus_install {
  if [ -d $HOME/.vim ]; then
    cd $HOME/.vim && rake
  else
    echo "Could not locate \$HOME/.vim"
  fi
}
