#!/bin/bash

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# 初回シェル時のみtmux実行
#if [ $SHLVL = 1 ]; then
#  tmux
#fi

# 1つだけtmux実行
count=`ps aux | grep tmux | grep -v grep | wc -l`
if test $count -eq 0; then
    tmux
elif test $count -eq 1; then
    tmux a
fi

