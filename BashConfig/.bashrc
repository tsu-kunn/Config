#!/bin/bash

# .bash_confが存在すればそれを読み込む
if [ -f "${HOME}/.bash_conf" ]; then
    source "${HOME}/.bash_conf"
fi

# .bash_funcが存在すればそれを読み込む
if [ -f "${HOME}/.bash_func" ]; then
    source "${HOME}/.bash_func"
fi

# bash parameter completion for the dotnet CLI
function _dotnet_bash_complete()
{
    local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n' # On Windows you may need to use use IFS=$'\r\n'
    local candidates

    read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)
    read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
}

