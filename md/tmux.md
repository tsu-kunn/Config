# tmuxのショートカットキー
## 起動（セッション作成）

## ウィンドウ操作

## ペイン操作

## コピー操作

# .tmux.conf
```
# Prefix(Ctrl-b)をCtrl-jに変更する
unbind-key C-b
set-option -g prefix C-j
bind-key C-j send-prefix

# 256色端末を使用する
set -g default-terminal "screen-256color"

# ステータスバーの背景色を変更する
set-option -g status-bg "colour255"

# マウス操作を有効にする
setw -g mouse on

# マウスでウィンドウ・ペインの切り替えやリサイズを可能にする
set-option -g mouse on

# コピーモードのキー操作をviライクにする
#set-window-option -g mode-keys vi

```

# 参考
[tmuxの使い方](https://tex2e.github.io/blog/linux/tmux-tutorial)

