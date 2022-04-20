#!/bin/bash

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# 初回シェル時のみ tmux実行
if [ $SHLVL = 1 ]; then
  tmux
fi

# 初回シェル時のみ Docker を実行
if test $(service docker status | awk '{print $4}') = 'not'; then #停止状態
  sudo service docker start
fi

