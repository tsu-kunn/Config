# tmuxのショートカットキー
※prefix\
default: `Ctrl + t`\
setting: `Ctrl + j`

## 起動（セッション作成）
|key|動作|
|:--|:--|
|tmux|セッション作成|
|tmux new -s 名前|名前付きセション作成|
|tmux a|中断していたセッションに戻る|
|tmux a -t 名前|中断していた名前付きセッションに戻る|
|tmux ls|セッションの一覧表示|
|tmux kill-session -t 名前|指定したセッションを終了|
|prefix d|セッションを一時的に中断|
|prefix $|セッション名の変更|
|exit|セッション終了|

## ウィンドウ操作
|key|動作|
|:--|:--|
|prefix c|ウィンドウの作成|
|prefix n|次のウィンドウに移動|
|prefix p|前のウィンドウに移動|
|prefix l|以前のウィンドウに移動|
|prefix [0-9]|ウィンドウの移動|
|exit|ウィンドウを終了|

## ペイン操作
|key|動作|
|:--|:--|
|prefix "|上下に分割|
|prefix %|左右に分割|
|prefix 矢印| ペインを移動|
|prefix o|次のペインに移動|
|prefix ;|以前のペインに移動|
|prefix q|ペイン番号を表示|
|prefix {|ペイン順序を前方向に入れ替え|
|prefix }|ペイン順序を後方向に入れ替え|
|prefix z|ペインを最大化・復帰|
|prefix space|ペインのレイアウトを変更|
|prefix x or exit|ペインを終了|

## コピー操作
|key|動作|
|:--|:--|
|prefix [|コピーモード開始|
|prefix ]|貼り付け|
|q|コピーモード終了|
|space|コピー開始位置決定|
|enter|コピー選択を終了|
|h j k l|カーソル移動|
|Ctrl + u|スクロールアップ|
|Ctrl + d|スクロールダウン|

## その他
|key|動作|
|:--|:--|
|prefix ?|キーバインドの一覧を表示|
|prefix :|コマンド入力モード|


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
- [tmuxの使い方](https://tex2e.github.io/blog/linux/tmux-tutorial)
- [tmux入門 - とほほのWWW入門](https://www.tohoho-web.com/ex/tmux.html)


