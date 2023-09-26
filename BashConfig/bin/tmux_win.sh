#!/bin/bash

# ファイラーWindow
tmux new-window -n "filer"
tmux send-keys "vifm" C-m

# 新規Window
tmux new-window -n "work"

# 画面分割
tmux split-window -v -p 75
tmux split-window -h -p 50

# 上部はtop、下部はgoto_projects実行
tmux send-keys -t 0 "top" C-m
tmux send-keys -t 1 "goto_projects IPMonitor_Tegra" C-m

tmux select-pane -t 2

# Windowを0に戻す
# tmux select-window -t 0

