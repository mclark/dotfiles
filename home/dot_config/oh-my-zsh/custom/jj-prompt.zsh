autoload -Uz add-zsh-hook
setopt prompt_subst

typeset -g JJ_PROMPT_ARROW="%F{green}➜%f"
typeset -g JJ_PROMPT_REPOSITORY=""
typeset -g JJ_PROMPT_DIRECTORY=""
typeset -gi JJ_PROMPT_REFRESH=1

_jj_prompt_find_repository() {
  local directory="$PWD"

  while true; do
    if [[ -e "$directory/.jj" ]]; then
      print -r -- "jj"
      return
    fi

    if [[ -e "$directory/.git" ]]; then
      print -r -- "git"
      return
    fi

    [[ "$directory" == "/" ]] && return
    directory="${directory:h}"
  done
}

_jj_prompt_update_repository() {
  local repository_kind="$(_jj_prompt_find_repository)"
  local output change_id bookmarks conflict
  local -a details

  JJ_PROMPT_REPOSITORY=""

  if [[ "$repository_kind" == "git" ]]; then
    JJ_PROMPT_REPOSITORY=" %F{yellow}git-only%f"
    return
  fi

  [[ "$repository_kind" == "jj" ]] || return

  output="$(
    command jj \
      --ignore-working-copy \
      --no-pager \
      log \
      --no-graph \
      --color=never \
      -r @ \
      -T '
        format_short_change_id_with_change_offset(self)
        ++ "\n"
        ++ if(bookmarks, bookmarks.join(","), "-")
        ++ "\n"
        ++ if(conflict, "conflict", "-")
        ++ "\n"
      ' 2>/dev/null
  )" || {
    JJ_PROMPT_REPOSITORY=" %F{red}jj:?%f"
    return
  }

  details=("${(@f)output}")
  change_id="${details[1]:-?}"
  bookmarks="${details[2]:--}"
  conflict="${details[3]:--}"

  bookmarks="${bookmarks//\%/%%}"
  JJ_PROMPT_REPOSITORY=" %F{blue}jj:%f%F{magenta}${change_id}%f"
  if [[ "$bookmarks" != "-" ]]; then
    JJ_PROMPT_REPOSITORY+=" %F{yellow}${bookmarks}%f"
  fi
  if [[ "$conflict" == "conflict" ]]; then
    JJ_PROMPT_REPOSITORY+=" %F{red}!%f"
  fi
}

_jj_prompt_precmd() {
  local command_status=$?

  if (( command_status == 0 )); then
    JJ_PROMPT_ARROW="%F{green}➜%f"
  else
    JJ_PROMPT_ARROW="%F{red}➜%f"
  fi

  if [[ "$JJ_PROMPT_DIRECTORY" != "$PWD" ]]; then
    JJ_PROMPT_DIRECTORY="$PWD"
    JJ_PROMPT_REFRESH=1
  fi

  if (( JJ_PROMPT_REFRESH )); then
    _jj_prompt_update_repository
    JJ_PROMPT_REFRESH=0
  fi

  PROMPT='${JJ_PROMPT_ARROW} %F{cyan}%1~%f${JJ_PROMPT_REPOSITORY} '
  return "$command_status"
}

_jj_prompt_preexec() {
  case " $1 " in
    *" jj "*|*" git "*)
      JJ_PROMPT_REFRESH=1
      ;;
  esac
}

_jj_prompt_chpwd() {
  JJ_PROMPT_REFRESH=1
}

add-zsh-hook -d precmd _jj_prompt_precmd 2>/dev/null
add-zsh-hook -d preexec _jj_prompt_preexec 2>/dev/null
add-zsh-hook -d chpwd _jj_prompt_chpwd 2>/dev/null
add-zsh-hook precmd _jj_prompt_precmd
add-zsh-hook preexec _jj_prompt_preexec
add-zsh-hook chpwd _jj_prompt_chpwd

precmd_functions=(
  _jj_prompt_precmd
  ${precmd_functions:#_jj_prompt_precmd}
)
