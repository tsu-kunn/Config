# Bash ショートカットキー

- Ctrl = C
- Alt = M

## 移動
|key|動作|
|:--|:--|
|C-f|→|
|C-b|←|
|M-f|単語単位で →|
|M-b|単語単位で ←|
|C-a|行頭へカーソルを移動|
|C-e|行末へカーソルを移動|

## 履歴
|key|動作|
|:--|:--|
|C-p|１つ前のコマンド履歴を見る|
|C-n|１つ先のコマンド履歴を見る|
|C-r|コマンド履歴の検索|
|M-.|直前のコマンドの引数を入力|

## 編集
|key|動作|
|:--|:--|
|C-t|１つ前と現在の文字を入れ替える|
|C-h|カーソルの左側の文字を削除(BS)|
|C-d|カーソルの文字を削除(DEL)|
|M-u|単語を大文字にする|
|M-l|単語を小文字にする|

## コピー＆ペースト
|key|動作|
|:--|:--|
|C-u|カーソル～行頭までを削除|
|C-k|カーソル～行末までを削除|
|C-w|カーソルより左側の単語を削除|
|M-d|カーソルより右側の単語を削除|
|C-y|貼り付け|

※正確に言えば、削除ではなくカット


## その他
|key|動作|
|:--|:--|
|C-l|画面をクリア|
|C-_|やり直し(Undo)|
|C-c|実行中のプログラムを強制終了|
|C-s|画面の更新を停止|
|C-q|画面の更新を再開|



# .bashrc
```bash
#!/etc/bash

# PATH
export LANG=ja_JP.UTF-8
export PATH=$PATH:"${HOME}/bin":

# history
export HISTSIZE=1000
export HISTCONTROL=ignoredups

# function
# cmd output SJIS->UTF-8
function wincmd()
{
	CMD=$1
	shift
	$CMD $* 2>&1 | iconv -f cp932 -t utf-8
}

function memow()
{
	NDIR="${HOME}/GitHub/Config/md/$1"
	EXT=$(basename $NDIR)
	EXT=${EXT##*.}

	if [ "$1" = "$EXT" ]; then
		NDIR="${NDIR}.md"
	fi

	vim $NDIR
}

function baktar()
{
	# ファイル名設定
	DATA=`date '+%Y%m%d_%k%M'`

	# 引数のチェック
	if [ $# -eq 0 -o "$1" = "-h" ]; then
		printf "baktar [option] [dirname]\n"
		printf "\n"
		printf "[option]\n"
		printf "  -h      : Help\n"
		printf "\n"
		printf "[dirname]\n"
		printf "  directory name\n"
		printf "\n"
	else
		FNAME=$(basename $1)"_${DATA}.tar.gz"
		tar cvzf $FNAME $1
	fi
}


# alias
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -al'
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias bashrc='source ~/.bashrc'
alias bash_profile='source ~/.bash_profile'

alias proj='. proj.sh' 
alias nip="memow $(date +"%Y%m")"

# prompt
# \u username \h hostname \w full path \W current path
export PS1='\[\e[00;32m\]\u@\H\[\e[00;34m\]:\w \$\[\e[00m\] '
```

## history
`export HISTSIZE=1000`

履歴の数を指定。初期値は環境に依存。

`export HISTCONTROL=ignoredups`

同じコマンドを入力した場合は履歴に保存しない。


## alias
よく使うコマンドを短縮して使えるように設定。

```
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
```

実行する際に確認をする。\
Linuxではデフォルト確認なしのため、誤操作防止でお勧めするところが多かったので追加。

## prompt
`export PS1='\[\e[00;32m\]\u@\H\[\e[00;34m\] \w \$\[\e[00m\] '`

- 表示内容
  - `\u`　ユーザー名
  - `\h`　ホスト名
  - `\w`　フルパス
  - `\W`　カレントパス
  - `\$`　権限（一般ユーザー: $, root: #）
- `\[\e[00;32m\]`
  - 00　装飾（0: none, 1: bold, 3: italic, 4: under line）
  - 32m　文字色（0: none, 30: 黒, 31: 赤, 32: 緑, 33: 黄, 34: 青, 35: 紫, 36: 水, 37: 灰）

## メモ
- シェルスクリプト内では `~/` は使えないので ${HOME} を使用する
- シェルスクリプト実行する際は、`. ` を頭に追加する
- 何も操作を受け付けなくなったら 'Ctrl-q' を押下する
  - それでもダメならターミナルが固まった疑惑


## 参考
- [ターミナルプロンプトの表示・色の変更](https://qiita.com/hmmrjn/items/60d2a64c9e5bf7c0fe60)

