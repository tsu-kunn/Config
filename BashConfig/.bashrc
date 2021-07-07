#!/etc/bash

# .bash_confが存在すればそれを読み込む
if [ -f "${HOME}/.bash_conf" ]; then
    source "${HOME}/.bash_conf"
fi

# .bash_setsが存在すればそれを読み込む
if [ -f "${HOME}/.bash_sets" ]; then
    source "${HOME}/.bash_sets"
fi

