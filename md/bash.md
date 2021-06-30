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
export PROMPT_DIRTRIM=3
export PATH=$PATH:"${HOME}/bin":

# history
export HISTSIZE=1000
export HISTCONTROL=ignoredups
PROMPT_COMMAND='history -a'

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
	FNAME=$(date +"%Y%m%d")

	if [ "$1" != "" ]; then
		FNAME=$1
	fi

	NDIR="${HOME}/GitHub/Config/md/$FNAME"
	BNAME=$(basename $NDIR)
	EXT=${BNAME##*.}

	if [ "$BNAME" = "$EXT" ]; then
		NDIR="${NDIR}.txt"
	fi

	vim "$NDIR"
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
		FNAME=$(basename "$1")"_${DATA}.tar.gz"
		tar cvzf "$FNAME" "$@"
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
alias nip="memow 日報/$(date +"%Y%m")"

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

### ディレクトリ階層数の制御
Bash 4.0以上であれば `PROMPT_DIRTRIM` を使って w/W のディレクトリ階層数を制御できます。

例) export PROMPT_DIRTRIM=3
```bash
hoge@hoge-PC:.../projects/GitHub/appClock $
```


# シェルスクリプト

## 計算
`$((...)) で囲うと計算になる。

例)
```bash
$ echo $((5 + 10))
15
```

### 変数で計算
exprコマンドを使用する。

例)
```bash
$ a=5
$ b=10
$ expr $a + $b
15
```

## 変数
### 設定
= の間にスペースを入れない。\
スペースを入れた場合は引数と判断される。

```bash
HOGE=10
HOGE="Hello"
```

### 値を表示
```bash
echo $HOGE
echo "$HOGE"
echo ${HOGE}
echo "${HOGE}"
```

※注意\
　シングルコーテーションで囲んだ場合は変数が展開されず、変数名が表示される。
```bash
echo '$HOGE'
$HOGE
```

### 値に追加
```bash
echo ${HOGE}3
echo ${HOGE}" World"
```

### 結合表示
```bash
echo ${HOGE0}${HOGE1}
```


## 特殊変数
- $0: シュルスクリプト名
- $*: "$1 $2 $3 ..." という1つの引数として受け取る
- $@: "$1" "$2" "$3" ... と複数の引数として受け取る
- $#: 引数の数
- $?: 直前に実行したコマンドの終了ステータス(0:true 0以外:false)

### 補足
引数を受け取る際は "$0", "$1" "$@" というように、"..." で囲むのが安全。\
引数に * など制御文字が入っていた場合や、空白を含む名前の場合は展開されてしまい、意図しない動作になる恐れがあります。

例) 引数と変数を "..." で囲み、空白を含む名前に対応
```bash
FNAME=$(basename "$1")"_${DATA}.tar.gz"
tar cvzf "$FNAME" "$@"
```

## 配列
```bash
arry=(1 2 3 4)

# 参照
echo ${arry[0]}
echo ${arry[3]}

# すべての要素
echo ${arry[@]}

# 要素数
echo ${#a[@]}
```

## 命令
### if
```bash
if [ 比較1 ]
then
  比較1が成の場合の処理
elif [ 比較2 ]
  比較2が成の場合の処理
else
  否の場合の処理
fi
```

### case
```bash
case string in
  expr1)
    expr1が成の場合の処理
    ;;
  expr2)
    expr2が成の場合の処理
    ;;
  *)
    否の場合の処理
    ;;
esac
```

### for
```bash
for 変数 in リスト or コマンド
do
  処理
done
```

### while
``` bash
while コマンド
do
  コマンドの返値が 0 の場合の処理
done
```

### until
``` bash
until コマンド
do
  コマンドの返値が 0 以外の場合の処理
done
```

## 比較
### 文字列
- s1 = s2  : 文字列s1 が文字列s2 と等しい
- s1 != s2 : 文字列s1 が文字列s2 と等しくない

### 数値
- a -eq b : 数値a とb が等しい
- a -ne b : 数値a が数値b と等しくない
- a -gt b : 数値a が数値 b より大きい
- a -ge b : 数値a が数値b 以上
- a -lt b : 数値a が数値b より小さい
- a -le b : 数値a が数値b 以下

## 関数
`function` は省略可能。

```bash
function hogeFunc() {
    for i in "$@"
    do
        echo "[$i]"
    done
}
```


## メモ
- シェルスクリプト内では `~/` は使えないので `${HOME}` を使用する
  - Git Bashでは環境変数に HOME を追加しないといけないかも…
- シェルスクリプト実行する際は、`. ` を頭に追加する
- 何も操作を受け付けなくなったら 'Ctrl-q' を押下する（Ctrl-sを押下した可能性あり）
  - それでもダメならターミナルが固まった疑惑
- bashのバージョン確認
  - '$ bash --version`


## 参考
- [ターミナルプロンプトの表示・色の変更](https://qiita.com/hmmrjn/items/60d2a64c9e5bf7c0fe60)
- [とほほのBash入門](https://www.tohoho-web.com/ex/shell.html)
