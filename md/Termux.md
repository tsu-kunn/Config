# Termuxのインストール方法
Google Playでの更新は終了しており、配布はF-Doroidというサイトから行われている。\
F-Doroidは全てオープンソースライセンスのものを取り扱っているとのことで、セキュリティはそこそこありそう。

## 配布先
[Termux | F-Droid - Free and Open Source Android App Repository](https://f-droid.org/packages/com.termux/)

※タイムアウトになるぐらいサイトが重い時がある。

### Google Play版からの移行方法（Termux のバックアップ）
[Backing up Termux](https://wiki.termux.com/wiki/Backing_up_Termux) に書かれている内容を実施する。\
Back up files の保存先は Android ストレージのディレクトリを指定してください。（Termuxアンインストールで消えてしまうため）

例)SDカードがない場合
```bash
$ tar -zcf ~/storage/downloads/termux-backup.tar.gz home usr 
```

## インストール
1. 配布サイトからダウンロードした apkファイル を Files などのアプリから実行する。
1. セキュリティに関する警告が表示されるので許可を与える。
1. インストールが終わったらアプリ一覧から Termux を実行する。
  - デスクトップに自動でショートカットが作られない 

※公式サイトでは F-Droid のアプリからインストールすることを推奨している。


# Termuxの設定方法

## パッケージ一覧
Git Hubの [termux-packages](https://github.com/termux/termux-packages/tree/master/packages) で確認できる。\
ここにないものはパッケージ追加できないので、パッケージ以外の方法で追加する必要がある。

## パッケージの更新
```bash
$ apt update
$ apt upgrade
```

Google Play からインストールしたばかりではパケージが古いので必ず最初に実行する。\
Termux 0.101 では100MB近くのパッケージ更新がある。

## 開発環境のパッケージを追加
```bash
$ apt install -y vim git openssh
```

エディターとしてVimを使い、ソース管理としてGitを利用する。\
Vimeは操作を覚えるまで使いにくいが、ワンキーでカーソル操作や編集ができるので、ソフトウェアキーボードとの相性がとても良い。\
Emacsの操作はCtrlとの組み合わせを多用するので、Vimほど快適に使いにづらい。

GitHubとのやり取りを SSH で行いたいので、 Open SSH も追加する。

### bash-completion
```bash
$ apt install -y bash-completion
```

BashでLinuxコマンドのオプションを補完をできるようにする。

### tig
```bash
$ apt install -y tig
```

コマンドライン(CUI)で使えるGitクライアント。\
Git操作をコマンドラインでできない場合は必須、できる場合も補助として入れておくと便利。\
Windows の Git Bashでも使えたりします。

### Node.js
```bash
$ apt install -y nodejs-lts yarn
```

yarn は必要に応じて追加。自分は npm 派なので追加してません。\
code-server を追加するなら入れましょう。

※2021/11/01\
パッケージを nodejs から nodejs-lts に変更。\
node のバージョンは v16.13.0

### nkf
パケージにはないので Git Hub からソースコードを取得し、 clang でコンパイルする。\
nkf 2.1.5 + Termix 0.116でコンパイルしたバイナリやインストール手順、コンパイル方法は下記を参照。

 [Release ver.2.1.5 Termux version · tsu-kunn/nkf](https://github.com/tsu-kunn/nkf/releases/tag/v2_1_5_Termux)。


### 開発言語
- clang
- golang
- perl
- php
- python
- python2
- ruby
- rust

ざっと見て目についた言語。

- cmake
- gdb
- make

ビルドツールもあったので C/C++開発も可能。\
以下のコマンドで Clang などの開発ツールをまとめて追加できる。

```bash
$ apt install -y build-essential"
```


## 内部ストレージにアクセス
```bash
$ termux-setup-storage
```

実行するとアクセス許可を求めるダイアログが表示されるので承認する。\
storage というディレクトリができ、ここから以下のフォルダにアクセスできる。

- dcim
- downloads
- external-1
  - SDカードの "/storage/[SD Card ID]/Android/data/com.termux/files" のリンクとなる。
  - ~~SDカードのルートや他のディレクトリにはアクセスできない。~~ → "/sdcard/" でアクセス可能でした。
  - アプリをアンインストールすると消えてしまうので注意！
- movies
- music
- pictures
- shared

## code-server のインストール

### 1. 必要パッケージをインストール
```bash
$ apt install -y nodejs yarn vim
```

### 2. code-sererをインストール
```bash
$ yarn global add code-server
```

※端末性能により5〜15分ほどかかる

### 3. "config.yaml" の作成
```bash
$ code-server
^C # Ctrl + C
```

1度実行して設定ファイルを作成する。

### 4. code-serverの設定
```bash
$ vi ~/.config/code-server/config.yaml
```

1. "auth" を none に変更
1. "password" 行を削除

```
bind-addr: 127.0.0.1:8080
auth: none # password を Noneに変更する
# passwordを行ごと消す
cert: false
```

### 5. code-serverへのアクセス
#### code-server 起動
```bash
$ code-server
```

#### ブラウザからアクセス
Chrome か Firefox で http://localhost:8080 にアクセス。

## 日本語入力
1. ソフトウェアキーボードの上に表示される ESC などが書かれた特殊キーエリアを左にスワイプする。
1. 空欄が表示され、日本語入力モードになり、日本語が入力可能となる。
    -  Bluetoothキーボードでも同様の方法で日本語入力が可能になる

※Vim など、日本語入力を受け付ける画面でないと正常に表示されない。

## Termux の設定
設定ファイルの作成。

```bash
$ mkdir ~/.termux
$ touch ~/.termux/termux.properties
```

### 特殊キーエリアの編集
"extra-keys" から始まる行のコメントアウトを削除し、使いやすいように値を編集する。\
　→ Default と Two rows がある

例）Two rows
```
extra-keys = [['ESC','TAB','-','HOME','UP','END','PGUP','DEL'], \
              ['CTRL','ALT','/','LEFT','DOWN','RIGHT','PGDN',':']]
```

### ターミナルセッションのショートカットキー
これを有効にすると screen などの仮想端末を入れなくても、複数のターミナルセッションを利用できる。\
SSH で外部から接続することがあるなら仮想端末を利用する方がよい。

例) `ctrl + t` は Bash のショートカットキーと被るので変更している。
```
# Open a new terminal with ctrl + t (volume down + t)
shortcut.create-session = ctrl + 3

# Go one session down with (for example) ctrl + 2
shortcut.next-session = ctrl + 2

# Go one session up with (for example) ctrl + 1
shortcut.previous-session = ctrl + 1
```

### フルスクリーンモード
v0.107 で追加された機能だけど、すべての端末で動作するとは限らない。（まだ不安定）

```
fullscreen = true
use-fullscreen-workaround = true
```

### 設定の反映
```bash
$ termux-reload-settings
```

## フォントの変更
`~/.termux/` に `font.ttf` を配置して、Termuxを再起動すると反映される。\
フォントサイズは `Ctrl + Alt + (+/-)` かピンチ操作で変更できます。\
変更したサイズは保存されているらしく、再起動しても保持されていました。

例) Myrica に変更
```bash
$ mkdir ~/tmp
$ cd ~/tmp
$ wget https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip
$ unzip Myrica.zip
$ mv Myrica.TTC ~/.termux/font.ttf
$ termux-reload-settings
$ cd ~/
$ rm -rf ~/tmp
```

## 参考URL
- [スマフォで始めるWebアプリ開発](https://zenn.dev/endo_hizumi/articles/887826624e04806ed9a2)
- [Termuxの意外と知らない日本語入力方法、特殊キータブの項目を増やす小技](https://qiita.com/gnuhead/items/3734a9dbf1146b59f12d)
- [Termux Wiki](https://wiki.termux.com/wiki/Main_Page)
