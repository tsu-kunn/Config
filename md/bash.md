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
|C-r|コマンド履歴の検索・前方検索|
|C-s|コマンド履歴の検索・後方検索|
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

## 補完
|key|動作|
|:--|:--|
|ESC-!|コマンド名を補完|
|ESC-/|ファイル名を補完|
|ESC-@|ホスト名を補完|
|ESC-~|ユーザー名を補完|
|ESC-$|変数名を補完|

## その他
|key|動作|
|:--|:--|
|C-l|画面をクリア|
|C-_|やり直し(Undo)|
|C-c|実行中のプログラムを強制終了|
|C-s|画面の更新を停止|
|C-q|画面の更新を再開|



# .bashrc
全体は以下を参照。
- [.bashrc](https://github.com/tsu-kunn/Config/blob/master/BashConfig/.bashrc)
- [.bash_conf](https://github.com/tsu-kunn/Config/blob/master/BashConfig/.bash_conf)
- [.bash_func](https://github.com/tsu-kunn/Config/blob/master/BashConfig/.bash_func)

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

# alias
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

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

# Proxy
Proxyを設定する必要がある場合は下記のように設定する。

## bashrc
```bash
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
export no_proxy="127.0.0.1, localhost, 192.168.1.1"
```

## .wgetrc
wget でうまくPorxy設定がいかない場合は `.wgetrc` を作成して以下を記載する。

```bash
use_proxy=on
http_proxy=http://proxy.example.com:8080
https_proxy=http://proxy.example.com:8080
check_certificate = off
```

## apt
sudo を付けるとrootの設定を参照するため別途設定する。\
または `sudo -E` として、ユーザー設定を維持して実行でも可。

`/etc/apt/apt.conf.d/01proxy` を作成して以下を記載する。
```bash
Acquire::http::Proxy "http://proxy.example.com:8080";
Acquire::https::Proxy "http://proxy.example.com:8080";
```

# リダイレクト
```bash
$ <command> > log.txt
$ <command> > log.txt 2> error.txt # 標準出力とエラー出力を分ける
$ <command> > log.txt 2>&1         # 標準出力とエラー出力をまとめる
$ <command> > /dev/null            # 標準出力を破棄
```

## 空ファイル作成
```bash
$ > file
$ cat /dev/null > file
```

## コマンドへの入力
```bash
$ <command> < hoge.txt
```

## プロセス置換
コマンドの出力結果をファイルとして扱う機能。(`<()` でコマンドをくくる)

```bash
$ <command> <(command)
```

## 標準入力
### キーボードから
```bash
$ read HOGE
```

|オプション|動作|
|:--|:--|
|-p|プロンプトを表示|
|-r|行の継続表示|
|-t [時間]|タイムアウトの設定|
|-n [最大入力文字数]|最大入力文字数の設定|
|-s|入力のエコーバックを抑制|

### ファイルから
```bash
$ read HOGE 0< test.txt
$ read HOGE < test.txt  # 0は省略可能
```

## 複数行リダイレクト
```bash
{
    echo "1.one"
    echo "2.two"
    echo "3.three"
} >> file
```

## 標準出力と標準エラーをまとめて出力
```bash
$ make 2>&1 | tee make_log
```

# 計算
`$((...))` で囲うと計算になる。

例)
```bash
$ echo $((5 + 10))
15
```

## 変数で計算
exprコマンドを使用する。

例)
```bash
$ a=5
$ b=10
$ expr $a + $b
15
$ echo $(($a + $b))
15
```

# 変数
## 設定
= の間にスペースを入れない。\
スペースを入れた場合は引数と判断される。

```bash
HOGE=10
HOGE="Hello"
```

### コマンドの実行結果を変数に保存
`` HOGE=`command` `` で結果を保存する。

```bash
$ HOGE=`ls -l`
```

※注意: 標準エラーに出力されたものは保存されない

または `$()` で囲む。

```bash
$ HOGE=$(lsb_release -i | awk '{print $3}')
$ echo $HOGE
```

### コマンドの実行結果をコマンドに渡す
上記と同じでバッククォートまはた `$()` で囲む。

```bash
$ basename "`pwd`"
$ echo "$(cal 1 2023)"
```

### エラーメッセージのみ変数に保存
```bash
$ HOGE=`ls -l hoge 2>&1 >/dev/null`
```

### 標準出力・標準エラーの両方を変数に保存
```bash
$ HOGE=`ls -l hoge 2>&1`
```


## 値を表示
```bash
$ echo $HOGE
$ echo "$HOGE"
$ echo ${HOGE}
$ echo "${HOGE}"
```

※注意\
　シングルコーテーションで囲んだ場合は変数が展開されず、変数名が表示される。
```bash
$ echo '$HOGE'
$HOGE
```

シングルコーテーションを表示したい場合は一度閉じてからバックスラッシュ記述する。
```bash
$ echo 'Let'\'s' Go!!'
```

## 値に追加
```bash
$ echo ${HOGE}3
$ echo ${HOGE}" World"
```

## 結合表示
```bash
$ echo ${HOGE0}${HOGE1}
```

## 部分文字列
### オフセット
```bash
$ echo ${HOGE:0:2}
$ echo ${HOGE:2:4}
```

### 最後からオフセット
```bash
$ echo ${HOGE:0:-2}
```

### 右端から最短パターン一致までを除外
```bash
$ HOGE=abc.def.ghi
$ echo ${HOGE%.*}
# => abc.def
```

### 右端から最長パターン一致までを除外
```bash
$ HOGE=abc.def.ghi
$ echo ${HOGE%%.*}
# => abc
```

### 左端から最短パターン一致まで除外
```bash
$ HOGE=abc.def.ghi
$ echo ${HOGE#*.}
# => def.ghi
```

### 左端から最長パターン一致まで除外
```bash
$ HOGE=abc.def.ghi
$ echo ${HOGE##*.}
# => ghi
```

## ローカル変数
```bash
local tmp="HOGE"
```

## 読み取り専用変数
```bash
readonly tmp="HOGE"
```

# 変数展開
|記述|動作|
|:--|:--|
|${param:-word}|${param}が NULL の場合 word に置き換える|
|${param:=word}|${param}が NULL の場合 word に置き換え、${param}に word を代入する|
|${param:?[word]}|${param}が NULL の場合 word を出力してシェルをエラー終了する|
|${param:+word}|${param}が NULL 以外の場合 word に置き換える|
|${#param}|${param}の文字列数に置き換える|
|${param#pattern}|param の値の文字列を左側から pattern に一致する最短の部分を取り除く（##で最長）|
|${param%pattern}|param の値の文字列を右側から pattern に一致する最短の部分を取り除く（%%で最長）|
|${param:offset:len}|param の値の文字列を左側から offset 個の文字を取り除き、最大 len 分展開する（lenは省略可）|
|${param/pattern/replace/}|param の値の文字列を左側から最初に pattern に一致した文字列を place に置き換える（//ですべて）|



## 参考HP
- [シェルの変数展開](https://qiita.com/bsdhack/items/597eb7daee4a8b3276ba)

# 特殊変数
- $0: シュルスクリプト名
- $*: "$1 $2 $3 ... ${10} ${11} ..." という1つの引数として受け取る
- $@: "$1" "$2" "$3" ... と複数の引数として受け取る
- $#: 引数の数
- $?: 直前に実行したコマンドの終了ステータス(0:true 0以外:false)
- $!: バックグラウンドで実行されたコマンドのPID
- $$: コマンド自身のPID
- $-: 現在のシュルに設定されているオプションフラグを参照
- $_: 直前に実行したコマンドの最後の引数を参照

## 補足
引数を受け取る際は "$0", "$1" "$@" というように、"..." で囲むのが安全。\
引数に * など制御文字が入っていた場合や、空白を含む名前の場合は展開されてしまい、\
意図しない動作になる恐れがあります。

例) 引数と変数を "..." で囲み、空白を含む名前に対応
```bash
FNAME=$(basename "$1")"_${DATA}.tar.gz"
tar cvzf "$FNAME" "$@"
```

# 配列
```bash
arry=(1 2 3 4)
arry[5]=5

# 参照
echo ${arry[0]}
echo ${arry[3]}

# すべての要素
echo ${arry[@]}

# 要素数
echo ${#a[@]}
```

# ブレース展開
```bash
$ ls *.{jpg,png,bmp}    # *.jpg, *.png, *.bmpに展開
$ ls *.LOG{1,2}
$ echo file{01..10}.txt # ゼロ埋め展開
```

# glob
bash には glob という機能がある。 \
主にワイルドカードの展開など。

## マッチングパターン
- `*`: 何にでもマッチする
- `?`: 任意の1文字にマッチする
- `[...]`: `[` と `]` の間に記述された任意の文字にマッチする
  - `[abc]`, `[a-z]` にマッチする
  - `[!123]`, `[!0-9]` 以外にマッチする

## 使用例
ファイル一覧を出力させる場合の例。 \
`ls` だとスペースのあるファイル名が分割されて表示されるが、`glob` を使うと期待動作になる。

```bash
$ touch 'this file includes spaces'
$ for l in *; do
    echo file name is "\"${l}\""
done
```

## 参考HP
- [BashのGlobは積極的に利用しましょう](https://kiririmode.hatenablog.jp/entry/20160731/1469930855)

# リスト
## &&
左側が真である場合のみ右側が実行される。

## ||
左側が偽である場合のみ右側が実行される。

# シェルスクリプト

## エラーチェック
シェルスクリプトの中に `set -eu` の設定を記載するとエラーチェックが有効になる。

- `e`: スクリプト内のコマンドがエラー終了した場合、スクリプトが自動で終了する。 ※[参考HP](https://qiita.com/ko1nksm/items/e73e343f609c071e6a8c)
- `u`: 未定義の変数を使おうとするとエラー終了する。

## シェルオプション
```bash
$ set -o [シェルオプション]
```

|シェルオプション|動作|
|:--|:--|
|pipefail|パイプラインの返値を最後のエラー終了値にする|
|noexec|実行せず構文チェックのみ行う|
|verbose|実行コマンドを出力する|
|xtrace|実行したコマンドとその引数を出力する|

### 参考HP
- [【 set 】コマンド――シェルの設定を確認、変更する](https://atmarkit.itmedia.co.jp/ait/articles/1805/10/news023.html)


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

1行手各場合は `;` が必要

```bash
if [ $hoge = "a"]; then echo "hogeは a "; fi
```

#### &&と||
```bash
[ "$i" -lt 10 ] && {  # if < 10
    echo "10未満"
    :
} || { # else
    echo "10以上"
}
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
  expr3|expr4)
    expr3かexpr4が成の場合の処理
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

例）
```bash
# リスト指定
for i in 1 2 3 4 5
do
  echo $i
done

# seq コマンドを使用
for i in `seq 1 5`
do
  echo $i
done
```

C言語のような記述も可能。

```bash
for ((i=0;i<10;i++)); do echo $i; done
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
|比較|動作|
|:--|:--|
|s1 = s2|文字列s1 が文字列s2 と等しい|
|s1 != s2|文字列s1 が文字列s2 と等しくない|

### 数値
|比較|動作|
|:--|:--|
|a -eq b|a == b|
|a -ne b|a !=b|
|a -gt b|a > b|
|a -ge b|a >=b|
|a -lt b|a < b|
|a -le b|a <= b|

### 条件
|条件|動作|
|:--|:--|
|&&(-a)| AND|
|\|\|(-o)| OR|
|!| NOT|

### testコマンド(ファイル)
|option|動作|
|:--|:--|
|-e file|file が存在するならば真|
|-f file|file が普通のファイルならば真|
|-d file|file がディレクトリならば真|
|-L file|file がシンボリックリンクならば真|
|-s file|file が 0 より大きいサイズならば真|
|-r file|file が読み取り可能ならば真|
|-w file|file が書き込み可能ならば真|
|-x file|file が実行可能ならば真|
|file1 -nt file2|file1 の変更時刻が file2 より新しい|
|file1 -ot file2|file1 の変更時刻が file2 より古い|

※真(0), 偽(1)\
※testコマンドは [ 条件式 ] で代用可能

### testコマンド(文字列)
|option|動作|
|:--|:--|
|-z|変数が空のとき真|
|-n|変数が空でないとき真|
|-v|変数が定義されているとき真|

### : (コロン)
何もしないで `0` を返す。

#### パラメーターの設定チェック
```bash
$ : ${1?'引数を指定してください'}
```

`$1` が未設定の場合エラーメッセージを表示する。

#### シェル変数のデフォルト設定
```bash
$ ${CFLAGS='-O2 -fomit-frame-pointer`}
```

`CFLAGS` が未設定の場合デフォルト値を代入

### eval
```bash
$ eval echo \"\$$var\"
```

引数を再度解釈してコマンドを実行する。

#### 例

```bash
$ day=Sunday
$ today=day
$ eval echo \"\$$today\"
Sunday
```


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

※注意\
関数には戻値はないので、戻値が必要な場合は標準出力で結果を返す必要がある。

## OS判別

```bash
OS='None'

case $(uname -a) in
    Darwin*)
        OS='Mac'
        ;;
    Linux*)
        OS='Linux'
        ;;
    MINGW64_NT*)
        OS='Windows'
        ;;
    MSYS_NT*)
        OS='Windows'
        ;;
    *)
        echo "Your platform is not supported."
        ;;
esac
```

## オプション解析
値が必要なオプションには `:` を付ける。\
エラーメッセージを表示しない場合は、オプションの先頭に `:` を付ける。

```bash
while getopts :ab:c: OPT
do
    case $OPT in
        "a" ) FLG_A="TRUE" ;;
        "b" ) FLG_B="TRUE" ; VALUE_B="$OPTARG" ;;
        "c" ) FLG_C="TRUE" ; VALUE_C="$OPTARG" ;;
    esac
done
```

## 関数のパイプ対応
testコマンドの `-p` は名前付きパイプであれば true になる。\
パイプによる入力がある場合は標準入力を変数に入れる。

```bash
str=$@

if [ -p /dev/stdin ]; then
    if [ "`echo $@`" == "" ]; then 
        str=`cat -`
    fi
fi

～ $str を使った処理～
```

if文をまとめてもよい。
```bash
if [ -p /dev/stdin ] && [ "`echo $@`" == "" ]; then
    str=`cat -`
fi
```

### パイプのみ
パイプ処理のみで使用する場合はこちらの方がよい…かも。\
cat出力をパイプした場合、ちゃんと改行されるので。

```bash
function urlencode()
{
    while read -r line
    do
        ～ $line を使った処理～
    done
}
```

## 区切り文字変更
```bash
_IFS=$IFS
IFS=$'\n'

～処理～

IFS=$_IFS
```

## 相対パス⇒絶対パス変換
```bash
$ echo $(cd "相対パス" && pwd)
```

## 文字コードや改行コード確認
```bash
$ file <file path>
```

## ランダムなパスワード
```bash
$ cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1
```


## デバッグ
- `bash -n` でシンタックスチェックを実施
  - `-x` と `-v` との併用可能
- `bash -x` で実行中の変数や変数に設定する値が出力される
  - `+` がシェルスクリプトで実行されたコマンド
  - `++` が バッククオート内で実行されたコマンド
- `bash -v` で実行されるコマンドが出力される
  - 変数は展開されない
  - `-x` との併用可能
- スクリプト中に `:` で始まる行はヌルコマンドとなり処理されない
  - `-x` と併用することが前提
  - `$?` には影響を与えるので注意
  - 文字列の先頭を半角にしないと日本語が化ける

## パイプの先はサブシェル
Bashではパイプで結合した先はサブシェルとして実行される仕様がある。

```bash
#!/bin/bash

str="dummy"

cat <<'__EOT__' >temp.$$
hoge hoge
fuga fuga
foo foo
bar bar
__EOT__

cat temp.$$ | while read line
do
  str="$line"
done
```

この場合は str は `bar bar` ではなく `dummy` となる。（サブシェルで実行されているのでスコープが違う）\
対応としてはリダイレクトを使う。

```bash
while read line
do
  str="$line"
  exit
done <temp.$$
```

# JSON
BashでJSONを扱う場合は `jq` というツールを使うのがベターっぽい。\
⇒[公式サイト](https://stedolan.github.io/jq/)

## インストール
### Windows
1. 公式サイトのダウンロードから `Windows(64-bit)` を選択。
1. `jq-win64.exe` を `jq.exe` にリネーム。
1. PATHが通っているフォルダへコピー。

### Linux
```bash
$ sudo apt install jq
```

## 使い方
### 整形
```bash
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq .
$ cat json_test.json | jq .
```

### 絞り込み
```bash
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '.name'
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '."color list"[1]'
$ cat json_test.json | jq '.[0].name'
$ cat json_test.json | jq '.[1].num_list[1]'
$ cat json_test.json | jq '.[0].user_info
$ cat json_test.json | jq '.[].user_info'
```

### 変数へ代入
```bash
$ a=$(echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '.name')
$ b=$(cat json_test.json | jq '.[].user_info')
```

### 値の編集
```bash
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '.memo|="Miku!Miku!!"' # 追加
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '.name|="Miku"'        # 変更
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq 'del(.name)'           # 削除
```

### 要素の追加
```bash
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '. |= .+ {"Profile": {"name": "Miku", "age": 18}}'
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '. |= .+ {"fruit": ["apple", "strawberry", "pear"]}'
```

### 配列の追加
```bash
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq '."color list" += ["apple", "strawberry", "pear"]'
```

### 保存
```bash
$ echo '{ "name": "Taro", "age": 20, "color list": ["red", "green", "blue"] }' | jq . > jq_test.json
$ cat json_test.json | jq . > jq_test.json
```

### JSON作成
ヒアドキュメント機能を使用する。

```bash
$ num=100
$ str="Miyuki"
$ json=$(cat << EOS
{
  "number": ${num},
  "string": "${str}"
}
EOS
)
```

### オプション
|Option|動作|
|:--|:--|
|-r|ダブルクォーテーションなし|
|-C|色付きのJSONを出力|
|--tab|インデントをタブにする|
|--indent n|指定された数のスペースを使用(MAX:7)|

## 参考
- [jq コマンドを使う日常のご紹介](https://qiita.com/takeshinoda@github/items/2dec7a72930ec1f658af)
- [jqコマンドでjsonデータを整形・絞り込み](https://qiita.com/Nakau/items/272bfd00b7a83d162e3a)


# curl
wgetとよく比較されるツール…ではなく、ライブラリらしい。\
wgetは再帰的取得、1URLに対してどれだけ処理ができるかが特徴。\
ファイルをダウンロードするだけなら好きな方を使えばよい。

## オプション
|Option|動作|
|:--|:--|
|-o|ファイル出力|
|-O|リクエスト先の名前でファイル出力|
|-F|ファイルのアップロード|
|-s|プログレス出力抑制|
|-f|エラーレスポンスの出力抑制|
|-I|HTTP Header出力|
|-i|Response Header, Body出力|
|-v|リクエスト時のHeader出力|
|-u|<ユーザー:パスワード>指定(BASIC認証)|
|-L|リダイレクト先までアクセス|
|-#|プログレスバーで進捗表示|
|-C|ダウンロード再開|
|-x|プロキシーの指定|
|-X|HTTPメソッドの指定|
|-H|リクエストヘッダーの指定|
|-d|POSTリクエストの送信|
|-c|cookieの保存|
|-b|cookieを指定|
|-A|UserAgentを指定|
|-anyauth|認証方式自動判別|

## URLエンコード
```bash
$ u=$(curl -s -w '%{url_effective}\n' --data-urlencode '日本語エンコード' -G '')
$ echo ${u:2}
```

### ※補足: URLデコード
```bash
$ echo ${u:2} | nkf --url-input
```

### 保存
#### ファイル名指定
```bash
$ curl -o dl_fille1.zip http://exapmle.com/sample.zip
```

#### リクエスト先の名前
```bash
$ curl -O http://exapmle.com/sample.zip
```

### 連番保存
```bash
$ curl -O "http://example.com/[001-100].jpg"
```

#### 名前が重複する場合
```bash
$ curl -o test#1 "http://example.com/[001-100].jpg"
```

### ファイルのアップロード
```bash
$ curl http://exapmle.com -X POST -F "file=@sample.txt"

# JSON
$ curl http://exapmle.com -X POST -F 'json={"parameter": [{"name":"FileParameter", "file":"file"}]}'
```

※注意: `-F` と `-d` は併用できない。(エラーになる)

### プログレスバー
```bash
$ curl -# http://example.com
```

### 標準出力抑制
```bash
$ curl -s http://exapmle.com  # エラーメッセージも抑制
$ curl -Ss http://exapmle.com # エラーメッセージは出力
```

### 認証
```bash
$ curl --basic -u user:pass http://example.com  # BASIC認証
$ curl --digest -u user:pass http://example.com # Digest認証
```

```bash
$ curl --anyauth --user user:pass http://example.com
```

### JSON
```bash
$ curl -X POST -H "Content-Type: application/json" -d '{"name":"美幸", "age":"23"}' http://example.com
$ curl -X POST -H "Content-Type: application/json" -d '@sample.json' http://example.com
```

### cookie
#### cookieの保存
```bash
$ curl -c cookie.txt http://example.com/cookies/test/value
```

#### cookieの利用
```bash
$ curl -b cookie.txt http://exapmle.com/cookies{"cookies":"{"test":"value"}}
```

### UserAgent
```bash
$ curl -A "UserAgent" http://exapmle.com
```

### proxy
```bash
$ curl -x http://proxy.example.com:8080 http://example.com
```

## 参考
- [curl コマンド 使い方メモ](https://qiita.com/yasuhiroki/items/a569d3371a66e365316f)

# wget
curlとよく比較されるツール。\
再起処理やダウンロードのダウンロード再開機能を目的に使用される。

wgetはBASIC認証のみ対応。

## オプション
|オプション|動作|
|:--|:--|
|-b|バックグラウンドで実行|
|-o ファイル名|経過メッセージをファイルに保存|
|-a ファイル名|経過メッセージをファイルに追加保存|
|-q|経過メッセージを非表示|
|-O|保存先の指定|
|-i ファイル名|指定したファイルからダウンロードするURLを読み込む|
|-t 回数|リトライ回数の指定(default:20)|
|-w 秒数|リトライの待ち時間を指定|
|-nc|上書き保存しない|
|-c|続きからダウンロード開始|
|-N|タイムスタンプをサーバー上のものを使用|
|-r|再帰ダウンロードを実施する|
|-l 数|再帰する改装を指定(default:5階層)|
|-p|ローカルで表示するために必要なファイルを含めてダウンロード|
|-k|ダウンロードファイル内のURLをローカル閲覧用に変換|
|-R 拡張子|指定した拡張子はダウンロードしない|
|-A 拡張子|指定した拡張子のみダウンロードする|
|-nAp|親ディレクトリを対象としない|
|-S|サーバーの応答情報を取得|
|--spider|ファイルをダウンロードせずにURLの存在だけ確認|
|--user=ユーザー名|ダウンロードする際のユーザー名|
|--password=パスワード|ダウンロードする際のパスワード|

## Webページを丸ごとダウンロード
```bash
$ wget -r -l 5 -np -p -k http://www.exapmle.com/
```

## ダウンロードを途中から再開
```bash
$ wget -c http://www.exapmel.com/
```

## 保存先指定
```bash
$ wget -c -O /tmp/hoge http://www.example.com/
```

## ダウンロード速度制限
```bash
$ wget --limit-rate=2m -c http://example.com/
```

## UserAgentの偽装
```bash
$ wget --user-agent="UserAgent" http://example.com/
```

## OAuth認証
```bash
$ wget --save-cookies cookies.txt --post-data 'user=hoge&password=hoge' http://example.com/auth.html
$ wget --load-cookies cookies.txt -p http://exapmle.com/hoge/
```

# コマンド備忘録

## 代表的なフィルターコマンド
|コマンド名|動作|
|:--|:--|
|cat|入力をそのまま表示|
|head|先頭の部分を表示|
|tail|末尾の部分を表示|
|grep|指定した検索パターンに一致する行だけを表示|
|sort|順番に並べる|
|uniq|重複した行を取り除く|
|tac|逆順に出力|
|wc|行数やバイト数を表示|
|tee|標準出力とファイルに書き出す|

## basename
```bash
$ basename '/home/user/bin/tmux_win.sh'
tmux_win
```

### ファイルのリネーム
```bash
for file in *.txt
do
    name=`basename "$file" .txt`
    mv "$name".txt "$name".log
done
```

## dirname
```bash
$ dirname '/home/user/bin/tmux_win.sh'
/home/user/bin
```

## wc
```bash
$ wc -l <ファイル名> # 行数を表示
$ wc -w <ファイル名> # 単語数を表示
$ wc -c <ファイル名> # バイト数を表示
```

## sort
```bash
$ ls -l | sort -k <フィールド番号> # フィールドの値でソート
$ cat hoge.txt | sort -n           # 文字列を数字とみなしてソート
$ cat hoge.txt | sort -r           # 逆順にソート
```

## cut
```bash
$ cut -d <区切り文字> -f <フィールド番号> [<ファイル名>]
```

## grep
```bash
$ grep [オプション] <検索パターン> <ファイル名>
```

- オプション(一部)
  - `-v`: 正規表現で一致しない行のみ表示
  - `-c`: マッチした行数を表示
  - `-n`: マッチした行の前に行番号を表示
  - `-i`: 大文字と小文字を区別しない
  - `-w`: 完全な単語マッチした行のみ表示
  - `-r`: 各ディレクトリ下のすべてのファイルを再帰的に読み取る
  - `-H`: 常にファイル名を表示

### プロセスをgrepした際に自身を取り除く方法
```bash
$ ps -ax | grep [h]oge
```

### 重複削除
```
$ ps -ax | grep hoge | sort -u
$ ps -ax | grep hoge | uniq
```

## sed
```bash
$ sed 1d txt       # 1行目を削除
$ sed 2,5d txt     # 2～5行目を削除
$ sed /^B/d txt    # 先頭がBで始まる行を削除
$ sed -n /^-/p txt # 一致する行を表示
$ sed -e s/置換前文字列/置換後文字列/フラグ

# 置換した結果を入力ファイルに保存(直接編集)
$ sed -i -e s/置換前文字列/置換後文字列/フラグ
```

- フラグ
  - `g`: 見つかったすべての文字列を置換
  - `p`: 置換が発生した場合のみ出力

## awk
```bash
$ ls -l | awk '{print $5,$9}'                  # 5行目と9行目を表示
$ ls -l | awk '{print $(NF-1),$NF}'            # 後ろから2番目と1番目のフィールドを表示
$ ls -l | awk '$NF ~ /^W/ {print $(NF-1),$NF}' # 最後のフィールドが 'W' で始まる行を表示
$ ls -l | awk '/^-/ {print $(NF-1),$NF}'       # '-' で始まる行を表示
$ awk -F "," `{print $2}` csv             # "," 区切りの2番目を表示
```

※`$NF`: 最後のフィールド番号
※`$NR`: 行番号(1～)

## find
```bash
$ find <検索パス> -name <検索文字>
$ find <検索パス> -type<f/d/l/b/c/p/s> -name <検索文字>
$ find <検索パス> -regextype posix-basic --regex <正規表現>
```

- type
  - f: ファイル
  - d: ディレクトリ
  - l: シンボリックリンク
  - b: ブロックデバイスファイル
  - c: キャラクタデバイスファイル
  - p: 名前付きパイプ
  - s: ソケット

## locate
DBを使った検索。インストールが必要。

### インストール
```bash
$ sudo apt install mlocate
```

### DBの更新
```bash
$ sudo updatedb
```

### 検索
```bash
$ locate <option> <検索文字列>
```

検索文字列はワイルドカードも可能。

- option（一部）
  - `-b`: 上位ディレクトリは検索しない
  - `-c`: 検索された数を表示
  - `-e`: 現存するファイルやディレクトリのみを検索する
  - `-i`: 大文字小文字を区別しない
  - `-r`: 正規表現で検索する

## xargs
```bash 
$ xargs <コマンド>

# マッチした markdonw file の先頭5行を表示
$ find . -type f -name "*.md" | xargs head -n 5

# マッチした markdown file から "メモ" を検索
$ find . -type f -name "*.md" | xargs grep "メモ"
```

## df
```bash
$ df -h
```

- オプション(一部)
  - `-h`: サイズに応じて読みやすい単位で表示
  - `-k`: 1K単位で表示
  - `-m`: 1M単位で表示
  - `--total`: 全体の合計を表示

## du
```bash
$ du -h -d 1
```

- オプション(一部)
  - `-S`: サブディレクトリのサイズを含めない
  - `-s`: 指定したディレクトリの合計サイズのみ表示
  - `-d 深さ`: 集計するディレクトリの深さ

## dd
### ダミーファイルの作成
100MBのダミーファイルを作成。

```bash
$ dd if=/dev/zero of=DUMMY_FILE bs=1M count=100
```

- オプション（一部）
  - `if`: ファイルからの読み出し
  - `of`: ファイルへの書き込み
  - `bs`: １回に読み書きするブロックサイズ(K/M/G/T/Pの指定可能)
  - `count`: bs/ibsで指定したサイズのブロックを個数分コピー

※中身がランダムな場合
```bash
$ head -c 200m /dev/urandom > test.txt
```

### ISOファイルの作成
```bash
$ dd if=/dev/cdrom of=install.iso
```

## vmstat
```bash
$ vmstat <更新間隔>
```

- proc
  - r: CPUへのアクセスを待っているプロセスの数（大きいとCPU負荷が大きい）
  - b: 入出力待ちでスリープ状態にされているプロセス数（大きいとI/O負荷などが大きい）
- memory
  - swpd : 仮想メモリ量
  - free : 空きメモリ量
  - buff : バッファに使用されているメモリ量
  - cache: ページキャッシュとして使用されているメモリ量
- swap
  - si: ディスクからスワップインしたディスクメモリの量
  - so: ディスクにスワップアウトしたディスクメモリの量
- io
  - bi: ブロックデバイスから受け取ったブロック
  - bo: ブロックデバイスに送られたブロック
- system
  - in: 1秒当たりの割り込み回数
  - cs: 1秒当たりのコンテキストスイッチの回数
- CPU
  - us: ユーザーが使用したCPUの割合（%)
  - sy: システムが使用したCPUの割合（%)
  - id: CPUのアイドル（%)
  - wa: IOの待ち時間

### 参考HP
- [vmstat - サーバー管理でよく使うコマンド](https://www.fulldigit.co.jp/command/s1_vmstat.html)

## コマンドの位置
```bash
$ which コマンド名
```

## OSバージョン
### カーネル
```bash
$ uname -a
```

### ディストリビューション
```bash
$ lsb_release -a
```

```bash
$ cat /etc/os-release
```

## SSH
### 秘密鍵の作成
```bash
$ ssh-keygen -t rsa -f <秘密鍵名>
$ chmod 600 <秘密鍵名>
```

`-f` を省略した場合は `id_rsa` になる。\
既存のものがあると上書きわれるので注意。\
秘密鍵は `~/.ssh/` に保存する。

### 秘密鍵指定
```bash
$ ssh -4/6 -i <秘密鍵のファイルパス> <ユーザー名>@<ドメイン名> -p <ポート番号>
```

- `-4` を指定した場合はIPv4、`-6` を射ていした場合はIPv6。（省略可能）
- `-i` を省略した場合は `id_rsa` が使われる。
- `-p` を省略した場合は `22番ポート` が使われる。

この指定を省略したい場合は `.ssh` ディレクトリ内に `config` を作成する。

```
Host alias名
  HostName IP address or Domain Name
  User UsarName
  IdentityFile ~/.ssh/hoge
  Port 22
```

### サーバー側の設定
#### .sshディレクトリ作成と authorized_keys に公開鍵を追加
```bash
$ cd ~
$ mkdir .ssh
$ chmod 700 .ssh
$ cd .ssh
$ cat hoge.pub >> authorized_keys
$ chmod 600 authorized_keys
```

`authorized_keys` に追加した後は `hoge.pub` を削除してもよい。

#### sshd設定の変更
```bash
$ sudo vi /etc/ssh/sshd_config
```

以下に設定を変更する。

```
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
```

設定が終わったら `sshd` を再起動する。

```bash
$ /etc/init.d/sshd restart
or
$ sudo systemctl restart sshd
```

## scp
```bash
$ scp -i <秘密鍵名> -p <ポート番号> <ユーザー名>@<ドメイン名>
```

- `-i` を省略した場合は `id_rsa` が使われる。
- `-p` を省略した場合は `22番ポート` が使われる。

SSHの `configファイル` を利用する場合。

```bash
$ scp <HOST名>
```

### 受信例
```bash
$ scp user@example.com:~/Documents/sample.txt ./test
$ scp hostname:~/Documents/ssample.txt ./test
```

### 送信例
```bash
$ scp ./test/test.txt user@example.com:~/Downloads
$ scp ./test/test.txt hostname:~/Downloads
```

### ディレクトリのコピー
`-r` を付ける。

```bash
$ scp -r user@example.com:~/Documents/test ./
```

## 秘密鍵の保存
```bash
$ eval "$(ssh-agent)"

$ ssh-add ~/.ssh/id_rsa
$ ssh-add ~/.ssh/hogekey
```

### 保存している鍵の確認
```bash
$ ssh-add -l
```

### 保存している鍵の削除
```bash
$ ssh-add -d ~/.ssh.id_rsa # 個別削除
$ ssh-add -D # すべて削除
```

### ssh-agentの修了
```bash
$ ssh-agent -k
```

## 圧縮・解凍
### 圧縮
```bash
$ tar cvzf hoge.tar.gz [file/directory]
$ tar cvjf hoge.tar.bz2 [file/directory]
$ 7za a hoge.7z [file/directory]
$ 7za a -tzip hoge.zip [file/directory]
$ zip -r hoge.zip [file/directory]
$ zip -r -p [password] hoge.zip [file/directory]
$ lha a hoge.lzh [file/directory]
$ gzip [file]
```

### 解凍
```bash
$ tar xvf hoge.tar.gz
$ tar xvf hoge.tar.bz2
$ 7za x hoge.7z
$ 7za x hoge.zip
$ unzip hoge.zip
$ lha x hoge.lzh
$ gzip -d hoge.gz
$ gnuzip hoge.gz
```

※gzip で元のファイルを残す場合は `-k` を付ける。

### tarで一部のファイル・ディレクトリを除外
`--exclude パターン` を追加することで除外ができる。\
パターンにはワイルドカードが使用できる。

除外は圧縮・解凍両方で指定可能。

```bash
$ tar --exclude tmp cvzf hoge.tar.gz
$ tar --exclude test* cvzf hoge.tar.gz
$ tar --exclude test[12]* cvzf hoge.tar.gz
$ tar --exclude test* xvf hoge.tar.gz
```

## ls結果の加工
### ファイルのみ出力
`-F` オプションでディレクトリ名の最後に"/"が表示されるようになるので、一致するものを除外する。

```bash
$ ls -F | grep -v /
```

### ディレクトリのみ出力
```bash
$ ls -d */
```

## ヒアドキュメント
複数行のテキスト出力を行う方法。

```bash
$ cat << EOF
test1
test2
EOF
```

### ファイルに出力する

```bash
$ cat << EOF > test.txt
test1
test2
EOF
```

### 変数展開をやめる

```bash
$ cat << 'EOF' >> test.txt
test1
test2
$HOME
EOF
```

## patch
`diff` コマンドと `patch` コマンドを使ったパッチの作成と適用方法。 \
`git` コマンドも同様の手段がある。

### patch ファイルの作成
```bash
$ diff -u <古いファイル> <新しいファイル> > hoge.patch
```

#### git
```bash
$ git diff > hoge.patch
```

### patch ファイルの適用
```bash
$ patch -u <ファイルパス> < hoge.patch
```

#### git
```bash
$ patch -p1 < hoge.patch
```

### 変更取り消し
```bash
$ patch -R <ファイルパス> < hoge.patch
```

### 参考HP
- [Git で変更を patch ファイルにする / patch コマンドで適用する](https://qiita.com/sea_mountain/items/7d9c812e68a26bd1a292)

# システムモニタリング
## sarコマンドのインストール
```bash
$ sudo apt install sysstat
```

## 使い方
```
$ sar [ オプション ] [ <時間間隔> [ <カウント数> ] ]
```

## オプション
ここに記載したもの以外のものは `--help` で確認。

- `-r`: メモリ使用量の統計
- `-u`: CPU使用量の統計
  - `-P ALL`: 各コアごとに表示
- `-W`: スワップの統計
- `-b`: I/Oおよび転送レートの統計
- `-n DEV`: ネットワークの統計

## 参考HP
- [Linuxリソースの監視・確認に関するコマンド逆引きメモ](https://qiita.com/rsooo/items/42f0902d42bab6ecf175)
- [sarコマンドでLinuxサーバのシステムモニタリングを行う方法](https://naoberry.com/tech/sar/)


# Git Bash
## Git for Windows のアップデート
```Bash
$ git update-git-for-windows
```

## pacmanのインストール＆tmuxのインストール
pacmanをインストールし、これを使って tumx をインストールする。\
インストール作業は管理者権限で起動した Git Bash を使用する必要がある。

```bash
git clone --depth=1 https://github.com/git-for-windows/git-sdk-64 gfw-sdk

cp gfw-sdk/usr/bin/pacman* /usr/bin/
cp -a gfw-sdk/etc/pacman.* /etc/

# 今後に備えて不足分のDLLをコピーしておく
cp -n gfw-sdk/usr/bin/*.dll /usr/bin

mkdir -p /var/lib/
mkdir -p /usr/share/makepkg/
cp -a gfw-sdk/var/lib/pacman /var/lib/
cp -a gfw-sdk/usr/share/makepkg/util* /usr/share/makepkg/

pacman --database --check

curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/master/git-for-windows-keyring/git-for-windows.gpg \
| pacman-key --add - \
&& pacman-key --lsign-key 1A9F3986

pacman -S tmux
```


## pacmanの基本的な使い方
|コマンド|動作|
|:--|:--|
|pacman -Syy|リポジトリの同期|
|pacman -Syu|パッケージのアップグレード|
|pacman -S <パッケージ名>|パッケージのインストール|
|pacman -Ss <パッケージ名>|パッケージの検索|
|pacman -Qs <パッケージ名>|インストールしたパッケージの検索|
|pacman -Ql|インストールされたパッケージの表示|
|pacman -R <パッケージ名>|パッケージの削除|
|pacman -Rs <パッケージ名>|依存するパッケージを含んだ削除|
|pacman -Sc|キャッシュのクリーンアップ|
|pacman -Scc|キャッシュの削除|


### 参考HP
[Windows で git bash + tmux な環境づくり](https://qiita.com/lemonjp/items/b39f042c1f282b8856d0)


## winpty の設定
対話モードを使うコマンドは `winpty` を付けないと正常に動作しないものがある。\
MinTTYの既知の不具合 or 仕様らしい。\
昔のバージョンでは `node` や `npm` は winpty が必要だったけど、 ver.2.32辺りからなしで動作する。\
　⇒逆に winpty がついていると正常に動作しない

`.bashrc` などで alias に登録しておくと楽です。\
　⇒ipython, php, php5, psql, python3 なども必要に応じて追加する

```bash
# Git Bash only
alias python='winpty python'
alias docker='winpty docker'
```

# 入力補完の強化
最近のディストリビューションでは標準で入っていると思うが、コマンドオプションの入力補完が欲しい場合は下記を実行する。

## インストール
```bash
$ sudo apt install bash-completion
```

## .bashrcの設定
```bash
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
```

## Git Bashでインストール
### pacman
1. パッケージのインストール
    ```bash
    $ pacman -S bash-completion
    ```
1. `.bashrc` に追加（手動4を実施）

### 手動
1. [リリースページ](https://github.com/scop/bash-completion/releases) からソースコードをダウンロード
1. ソースコードの展開\
    `bash-completion-2.11.tar.xz` をダウンロードした場合。
    ```bash
    $ xz -dv bash-completion-2.11.tar.xz
    $ tar xvf bash-completion-2.11.tar
    ```
1. make でインストール\
    Git for Windows環境の場合は、管理者権限で実行したGit Bashで `make install` を実行する必要あり。
    ``` bash
    $ cd bash-completion-2.11
    $ ./configure
    $ make
    $ make install
    ```
1. `.bashrc` に追加
    ```bash
    # bash-completion
    if [ -f /usr/local/share/bash-completion/bash_completion ]; then
      . /usr/local/share/bash-completion/bash_completion
    fi
    ```

### 参考HP
- [Git Bash for Windows で bash-completion を使う](https://zenn.dev/sprout2000/articles/e80168e97fc306)


# メモ
- シェルスクリプト内では `~/` は使えないので `${HOME}` を使用する
  - Git Bashでは環境変数に HOME を追加しないといけないかも…
- シェルスクリプト実行する際は、`. ` を頭に追加する
  - または `source` を追加
- 何も操作を受け付けなくなったら 'Ctrl-q' を押下する（Ctrl-sを押下した可能性あり）
  - それでもダメならターミナルが固まった疑惑
- bashのバージョン確認
  - `bash --version`
- `Ctrl + D` でシェルを終了しない
  - `set -o ignoreeof`
- `Ctrl + S` でシェルを停止しない
  - `stty stop undef`
- コマンドプロンプトのコマンドを実行する(Git Bash)
  - `cmd //c <command>` とスラッシュが2つ必要(1つだと新規プロセスになる)
- WSL2
  - Windows->Linux 
    - `\\wsl$\Ubuntu-20.04\home\%USERNAME%`
  - Linux->Windows
    - `/mnt/c/`
  - path変換
    ```bash
    $ wslpath "c:\files\work"
    ```
      - `-u` (defalt:省略可) でWindwosパスをWSLパスに変換
      - `-w` でWSLパスをWindowsパスに変換
- 覚えておくと便利な `cp` コマンドのオプション
  - `-n` 同名のファイルは上書きしない
  - `-p` 属性情報（タイムスタンプや権限など）をそのままにしてコピー
- ファイルのタイムスタンプを変更
  - `touch -t [[CC]YY]MMDDhhmm <file name...>` or `touch --date="20211028 12:00" <file name...>`
- グローバルIPの確認
  - `curl ifconfig.io`
- ソースコードの行数計算
  - `find . -name "*.c" | xargs wc -l`
- apt個別アップグレード
  - アップグレード可能なパッケージ: `sudo apt update && apt list --upgradable`
  - 個別にアップグレード: `sudo apt install <パッケージ名> --only-upgrade`
- パッケージの情報
  - `apt show <パッケージ名>`
- コマンド結果のdiff
  - `diff <(command1) <(command2)`
- パイプラインの終了ステータス
  - `${PIPESTATUS[@]}`
- 呼び出しシェルに影響を与えずに実行
  ```bash
  (
    cd /tmp
    cp -p "$hoge" "$hoge".bak
  )
  ```


# 参考
- [ターミナルプロンプトの表示・色の変更](https://qiita.com/hmmrjn/items/60d2a64c9e5bf7c0fe60)
- [とほほのBash入門](https://www.tohoho-web.com/ex/shell.html)
- [UNIX & Linux コマンド・シェルスクリプト リファレンス](https://shellscript.sunone.me/)
- [もっと使いやすいコマンドラインツール10選](https://zenn.dev/the_exile/articles/5176b7a5c29bce)

## 書籍
- Linuxハンドブック（オライリー絶版？）
- [シェルスクリプト基本リファレンス 第三版](https://amzn.to/3GlR1o7)

