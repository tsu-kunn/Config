#!/etc/bash

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# 初回シェル時のみ tmux実行
if [ $SHLVL = 1 ]; then
  tmux
fi
