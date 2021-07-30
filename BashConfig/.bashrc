#!/bin/bash

# .bash_confが存在すればそれを読み込む
if [ -f "${HOME}/.bash_conf" ]; then
    source "${HOME}/.bash_conf"
fi

# .bash_funcが存在すればそれを読み込む
if [ -f "${HOME}/.bash_func" ]; then
    source "${HOME}/.bash_func"
fi

