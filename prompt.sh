#! /usr/bin/env bash

# Author: Ryan Parman
# License: MIT
# Home: https://github.com/skyzyx/git-prompt

# See colors.sh for color-related variables

export GIT_EXTENDED_PROMPT_HASH=":"
export GIT_EXTENDED_PROMPT_CONFLICTED="\xC3\x97"
export GIT_EXTENDED_PROMPT_STAGED="\xE2\x88\x86"
export GIT_EXTENDED_PROMPT_CHANGED="*"
export GIT_EXTENDED_PROMPT_UNTRACKED="!"
export GIT_EXTENDED_PROMPT_AHEAD="+"
export GIT_EXTENDED_PROMPT_BEHIND="-"
export GIT_EXTENDED_PROMPT_OK="\xE2\x9c\x93"
export GIT_EXTENDED_PROMPT_NOK="\xE2\x80\xBC"
export GIT_EXTENDED_PROMPT_NOREMOTE="<local>"

# Make a backup
export OLD_PS1=$PS1

# Lookup the current git branch, if any
__wp_git_branch_lookup() {

  # Do we have GNU Sed installed?
  if [[ ! -z $(which gsed 2>/dev/null) ]]; then
    _sed=gsed
  elif [[ ! -z $(which sed 2>/dev/null) ]]; then
    _sed=sed
  else
    return;
  fi

  # Are we in a Git repo?
  git log -n 1 >/dev/null 2>&1

  if [[ $? = 0 ]]; then

    # Start - https://github.com/magicmonty/bash-git-prompt/blob/master/gitstatus.sh
    gitsym=`git symbolic-ref HEAD 2>/dev/null`
    branch="${gitsym##refs/heads/}"
    remote=

    if [[ -z "$branch" ]]; then
      tag=`git describe --exact-match 2>/dev/null`
      if [[ -n "$tag" ]]; then
        branch="$tag"
      else
        branch="$GIT_EXTENDED_PROMPT_HASH`git rev-parse --short HEAD`"
      fi
    else
      remote_name=`git config branch.${branch}.remote`

      if [[ -n "$remote_name" ]]; then
        merge_name=`git config branch.${branch}.merge`
      else
        remote_name='origin'
        merge_name="refs/heads/${branch}"
      fi

      if [[ "$remote_name" == '.' ]]; then
        remote_ref="$merge_name"
      else
        remote_ref="refs/remotes/$remote_name/${merge_name##refs/heads/}"
      fi

      # get the revision list, and count the leading "<" and ">"
      revgit=`git rev-list --left-right ${remote_ref}...HEAD 2> /dev/null`
      if [[ $? = 0 ]]; then
        num_revs=`__wp_all_lines "$revgit"`
        num_ahead=`__wp_count_lines "$revgit" "^>"`
        num_behind=$(( num_revs - num_ahead ))
        if (( num_behind > 0 )) ; then
          remote="${remote}${symbols_behind}${num_behind}"
        fi
        if (( num_ahead > 0 )) ; then
          remote="${remote}${symbols_ahead}${num_ahead}"
        fi
      else
        noremote=" $GIT_EXTENDED_PROMPT_NOREMOTE"
      fi
    fi
    if [[ -z "$remote" ]] ; then
      remote='.'
    fi
    # End - https://github.com/magicmonty/bash-git-prompt/blob/master/gitstatus.sh

    #----#

    if [[ $GIT_EXTENDED_PROMPT = 'true' ]]; then
      status=$(git status -s -uall)

      # Count commits ahead
      if [[ $num_ahead -ne 0 ]]; then
        num_ahead=" $GIT_EXTENDED_PROMPT_AHEAD$num_ahead"
      else
        num_ahead=""
      fi

      # Count commits behind
      if [[ $num_behind -ne 0 ]]; then
        num_behind=" $GIT_EXTENDED_PROMPT_BEHIND$num_behind"
      else
        num_behind=""
      fi

      # Count conflicted files
      conflicted=$(echo "$status" | $_sed -nr '/^UU/p' | wc -l | tr -d "\n" | sed 's/^ *//')
      if [[ $conflicted -ne 0 ]]; then
        conflicted=" $conflicted$GIT_EXTENDED_PROMPT_CONFLICTED"
      else
        conflicted=""
      fi

      # Count staged files
      staged=$(echo "$status" | $_sed -nr '/^[A-Z]/p' | wc -l | tr -d "\n" | sed 's/^ *//')
      if [[ $staged -ne 0 ]]; then
        staged=" $staged$GIT_EXTENDED_PROMPT_STAGED"
      else
        staged=""
      fi

      # Count changed files
      changed=$(echo "$status" | $_sed -nr '/^\s/p' | wc -l | tr -d "\n" | sed 's/^ *//')
      if [[ $changed -ne 0 ]]; then
        changed=" $changed$GIT_EXTENDED_PROMPT_CHANGED"
      else
        changed=""
      fi

      # Count untracked files
      untracked=$(echo "$status" | $_sed -nr '/^\?/p' | wc -l | tr -d "\n" | sed 's/^ *//')
      if [[ $untracked -ne 0 ]]; then
        untracked=" $untracked$GIT_EXTENDED_PROMPT_UNTRACKED"
      else
        untracked=""
      fi

      echo -ne "($branch$num_ahead$num_behind$conflicted$staged$changed$untracked$noremote)";
    else
      echo -ne "($branch)";
    fi
  else
    echo -ne "";
  fi
}

# Helper functions
__wp_count_lines() {
  echo "$1" | egrep -c "^$2";
}

__wp_all_lines() {
  echo "$1" | grep -v "^$" | wc -l;
}

# Did the last command finish successfully?
__wp_pass_fail() {
  if [[ $? = 0 ]]; then
    return 0;
  else
    return 1;
  fi
}

__wp_set_prompt_command_for_dark() {
  # Build prompt in reverse so that we can properly capture the last exit code
  export PS1="\[$fg_bwhite\]`if [ $? = 0 ]; then echo -e \"\[$bg_green\] $GIT_EXTENDED_PROMPT_OK \"; else echo -e \"\[$bg_red\] $GIT_EXTENDED_PROMPT_NOK \"; fi`\[$reset\] "
  export PS1="\[$fg_byellow\]\$(__wp_git_branch_lookup)\[$reset\] $PS1" # Git status
  export PS1="\[$fg_bblack\]\T\[$reset\] $PS1" # Time
  export PS1="[\[$fg_bgreen\]\u@\h\[$reset\]: \[$fg_white\]\[$bg_blue\] \w \[$reset\]] $PS1" # User, hostname, current path
}

__wp_set_prompt_command_for_basic() {
  # Build prompt in reverse so that we can properly capture the last exit code
  export PS1="\[$fg_bwhite\]`if [ $? = 0 ]; then echo -e \"\[$bg_green\] $GIT_EXTENDED_PROMPT_OK \"; else echo -e \"\[$bg_red\] $GIT_EXTENDED_PROMPT_NOK \"; fi`\[$reset\] "
  export PS1="\[$fg_green\]\$(__wp_git_branch_lookup)\[$reset\] $PS1" # Git status
  export PS1="\[$fg_bblack\]\T\[$reset\] $PS1" # Time
  export PS1="[\[$fg_black\]\u@\h\[$reset\]: \[$fg_blue\]\w\[$reset\]] $PS1" # User, hostname, current path
}

__wp_set_prompt_command_for_nocolor() {
  # Build prompt in reverse so that we can properly capture the last exit code
  export PS1="`if [ $? = 0 ]; then echo -e \" $GIT_EXTENDED_PROMPT_OK \"; else echo -e \" $GIT_EXTENDED_PROMPT_NOK \"; fi` "
  export PS1="\$(__wp_git_branch_lookup) $PS1" # Git status
  export PS1="\T $PS1" # Time
  export PS1="[\u@\h: \w] $PS1" # User, hostname, current path
}

__wp_set_prompt_noop() {
  export PS1=$OLD_PS1
}

# Always run on new prompt
if [ $GIT_EXTENDED_PROMPT_COLOR == "dark" ]; then
  export PROMPT_COMMAND="__wp_set_prompt_command_for_dark";
elif [ $GIT_EXTENDED_PROMPT_COLOR == "light" ]; then
  export PROMPT_COMMAND="__wp_set_prompt_command_for_basic";
elif [ $GIT_EXTENDED_PROMPT_COLOR == "nocolor" ]; then
  export PROMPT_COMMAND="__wp_set_prompt_command_for_nocolor";
else
  export PROMPT_COMMAND="__wp_set_prompt_noop";
fi;

#------------------------------------------------------------------------------#

shopt -s checkwinsize

# Tell the terminal about the working directory at each prompt.
if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
  update_terminal_cwd() {
      local SEARCH=' '
      local REPLACE='%20'
      local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
      printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="$PROMPT_COMMAND; update_terminal_cwd"
fi
