# Termuxの設定方法

## パッケージ一覧
Git Hubの [termux-packages](https://github.com/termux/termux-packages/tree/master/packages) で確認できる。\
ここにないものはパッケージ追加できないので、パッケージ以外の方法で追加する必要がある。

## パッケージの更新
```
$ apt update
$ apt upgrade
```

Google Play からインストールしたばかりではパケージが古いので必ず最初に実行する。\
Termux 0.101 では100MB近くのパッケージ更新がある。

## 開発環境のパッケージを追加
```
$ apt install -y vim git openssh
```

エディターとしてVimを使い、ソース管理としてGitを利用する。
Vimeは操作を覚えるまで使いにくいが、ワンキーでカーソル操作や編集ができるので、ソフトウェアキーボードとの相性がとても良い。
Emacsの操作はCtrlとの組み合わせを多用するので、Vimほど快適に使いにづらい。

GitHubとのやり取りを SSH で行いたいので、 Open SSH も追加する。

### tig
```
$ apt install -y tig
```

コマンドライン(CUI)で使えるGitクライアント。\
Git操作をコマンドラインでできない場合は必須、できる場合も補助として入れておくと便利。\
Windows の Git Bashでも使えたりします。

### Node.js
```
$ apt install -y nodejs yarn
```

yarn は必要に応じて追加。自分は npm 派なので追加してません。\
code-server を追加するなら入れましょう。

※2021/05/29\
node のバージョンは v14.15.4\
npm と npx のバージョンは 6.14.10

### 開発言語
- clang
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
"build-essential" でこれらや Clang をまとめて追加できる。


## 内部ストレージにアクセス
```
$ termux-setup-storage
```

実行するとアクセス許可を求めるダイアログが表示されるので承認する。\
storage というディレクトリができ、ここから以下のフォルダにアクセスできる。

- dcim
- downloads
- external-1
  - SDカードの "/storage/[SD Card ID]/Android/data/com.termux/files" のリンクとなる。
  - SDカードのルートや他のディレクトリにはアクセスできない。
- movies
- music
- pictures
- shared

## code-server のインストール

### 1. 必要パッケージをインストール
```
$ apt install -y nodejs yarn vim
```

### 2. code-sererをインストール
```
$ yarn global add code-server
```

※端末性能により5〜15分ほどかかる

### 3. "config.yaml" の作成
```
$ code-server
^C ※Ctrl + C
```

1度実行して設定ファイルを作成する。

### 4. code-serverの設定
```
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
```
$ code-server
```

#### ブラウザからアクセス
Chrome か Firefox で http://localhost:8080 にアクセス。

## 日本語入力
1. ソフトウェアキーボードの上に表示される ESC などが書かれた特殊キーエリアを左にスワイプする。
1. 空欄が表示され、日本語入力モードになり、日本語が入力可能となる。

※Vim など、日本語入力を受け付ける画面でないと正常に表示されない。

## 特殊キーエリアの編集
### 1. extra-keys の設定
```
$ mkdir ~/.termux
$ touch ~/.termux/termux.properties
```

"extra-keys" から始まる2行のコメントアウトを削除し、使いやすいように値を編集する。

例）
```
extra-keys = [['ESC','TAB','-','HOME','UP','END','PGUP','DEL'], \
              ['CTRL','ALT','/','LEFT','DOWN','RIGHT','PGDN',':']]
```

### 2. 設定の反映
```
$ termux-reload-settings
```

## 参考URL
- [スマフォで始めるWebアプリ開発](https://zenn.dev/endo_hizumi/articles/887826624e04806ed9a2)
- [Termuxの意外と知らない日本語入力方法、特殊キータブの項目を増やす小技](https://qiita.com/gnuhead/items/3734a9dbf1146b59f12d)

