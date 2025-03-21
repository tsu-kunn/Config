# Vim ショートカットキー

## ファイル
|key|動作|
|:--|:--|
|:e file|file を開く|
|:q|終了|
|:!q|保存せずに終了|
|:wq or ZZ|保存して終了|
|:w|変更を保存|
|:w file|file という名前で保存|
|:set fileencoding=n|文字コードを n に設定|
|:ol|開いたファイルの履歴|
|:e #\<XX|履歴の番号を指定してファイルを開く|
|:bro ol|履歴を指定してファイルを開く|


## タブ
|key|動作|
|:--|:--|
|:tabe|新しいタブを開く|
|:tabe file|新しいタブで file を開く|
|:tabc|表示中のタブを閉じる|
|:tabn or gt|右隣のタブに移動|
|:tabN or gT|左隣のタブに移動|
|:tab|表示中以外のタブを閉じる|
|:tabs|タブ一覧|
|{x}gt|x番目のタブに移動|


## 編集モード
|key|動作|
|:--|:--|
|i|挿入モード（カーソル位置）|
|a|挿入モード（カーソル位置の右側）|
|o|新しい行を追加して挿入モード|
|I|行頭に移動して挿入モード|
|A|行末に移動して挿入モード|
|R|置き換え（上書き）モード|


## カーソル移動
|key|動作|
|:--|:--|
|h|←|
|j|↑|
|k|↓|
|l|→|
|H|カーソルを画面上に移動|
|M|カーソルを画面中央に移動|
|L|カーソルを画面下に移動|
|Ctrl+d|半画面下に移動|
|Ctrl+u|半画面上に移動|
|Ctrl+f|１画面下に移動|
|Ctrl+b|１画面上に移動|
|gg|先頭に移動|
|G|末尾に移動|
|nG|n行目に移動|
|^ or 0|行頭に移動|
|$|行末に移動|
|w|次の単語に移動|
|b|前の単語に移動|
|zz|カーソルが画面中央になるように移動|
|%|対応するカッコに移動|


## 領域選択
|key|動作|
|:--|:--|
|v|ビジュアル（領域選択）モード|
|Ctrl+v|矩形選択モード|
|Shift+v|行選択モード|
|y|コピー|
|d|切り取り|
|p|貼り付け|
|=|選択領域をオートインデント|
|u|小文字に変換|
|U|大文字に変換|
|選択中+<|インデント削除|
|選択中+>|インテント挿入|


## 編集
|key|動作|
|:--|:--|
|yy|カーソルのある行をコピー|
|dd|カーソルのある行を切り取り|
|x|カーソルの下にある文字を削除|
|D|カーソル位置から行末まで削除|
|d^|カーソル位置から行頭まで削除|
|dw|単語削除|
|u|Undo|
|Ctrl+r|Redo|
|.|直前の変更を繰り返す|
|<<|インデント削除|
|>>|インデント挿入|
|Ctrl+a|数字のインクリメント|
|Ctrl+x|数字のデクリメント|

## 検索
|key|動作|
|:--|:--|
|/ w|wを検索（下方向）|
|? w|wを検索（上方向）|
|*|カーソル位置の単語を検索（下方向）|
|#|カーソル位置の単語を検索（上方向）|
|n or *|次の候補|
|N or #|前の候補|
|:%s/word/WORD/g|置換（wordをWORDに置換）|
|:%s/word/WORD/gc|確認しながら置換|

## ウィンドウ
|key|動作|
|:--|:--|
|:split|画面を上下に分割|
|:vsplit|画面を左右に分割|
|:close|ウィンドウを閉じる|
|:new file|新規ウィンドウで file を作成（垂直方向）|
|:vnew file|新規ウィンドウで file を作成（水平方向）|
|:e|表示中のウィドウにファイルを開く|
|:q|ウィンドウの削除|
|:hide|表示中のウィンドウを隠す|
|:only|他のウィンドウをすべて隠す|
|Ctrl+w +|ウィンドウを拡大|
|Ctrl+w -|ウィンドウを縮小|
|Ctrl+w w|別ウィンドウに移動|
|Ctrl+w k|上のウィンドウに移動|
|Ctrl+w j|下のウィンドウに移動|
|Ctrl+w h|左のウィンドウに移動|
|Ctrl+w l|右のウィンドウに移動|
|Ctrl+w r|左右/上下のウィンドウを入れ替え|

## バッファ管理
|key|動作|
|:--|:--|
|:ls|バッファ一覧を表示|
|:bn|次のバッファに移動|
|:bp|前のバッファに移動|
|:bd|バッファを削除|

## シェル
|key|動作|
|:--|:--|
|:! <コマンド>|コマンドを実行し、Vimに戻る|
|:r! <コマンド>|コマンドを実行し、結果をVimに取り込む|
|:sh|シェルを起動、シェルを終了するとVimに戻る|
|:source $MYVIMRC|`~/.vimrc` の再読み込み|

# Vimメモ
## vimgrep
`vimgrep /{pattern}/[j][c][C] {file} ...` で指定。

- j
  - 検索にヒットした行に移動しない
- c
  - 大文字、小文字を区別しない 
- C
  - 大文字、小文字を区別する

### 検索パターン
#### ローカル以下を検索
```
:vimgrep /hoge/ **/*.c
```

#### 指定のディレクトリ以下を検索
```
:vimgrep /hoge/ src/**/*.c
```

#### 編集中のファイルを検索 
```
:vimgrep /hoge/j %
```

## インデントの空白、スペース切り替え
- タブに設定\
  `set noexpandtab`
- 空白に設定\
  `set expandtab`

## インデントの空白、スペース相互変換
- タブ→空白
  ```
  :set expandtab
  :retab
  ```
- 空白→タブ
  ```
  :set noexpandtab
  :retab!
  ```

## ESCの代わり
- `Ctrl + [`
  - ESCの代替
- `Ctrl + c`
  - 途中だったコマンドがキャンセルされる

## 複数行編集
### 行頭
1. Ctrl + V で矩形選択
1. 対象の行を選択して I で挿入モードへ
1. 追加したい文字を入力
1. ESCで抜ける

### 行末
1. Ctrl + V で矩形選択
1. 対象の行を選択して $ で行末まで選択
1. A で挿入モードへ
1. 追加したい文字を入力
1. ESCで抜ける

## 選択した文字を検索
1. ビジュアルモードで検索文字をヤンク(`y`)
1. 検索(`/`)キーを押下
1. `C-r` の後に `"` を押下

## エンコーディング
### SJISで開きなおす
```vim
:edit ++encoding=sjis
```

### UTF-8で開きなおす
```vim
:edit ++encoding=utf-8
```

### UTF-8で保存する
```vim
:set fileencoding=utf-8
```

### エンコーディングの確認
```vim
:set encoding?
:set fileencoding?
```

## 改行コード
### 指定して開く
#### LF(Unix)
```vim
:edit ++fileformat=unix
```

#### CRLF(DOS)
```vim
:e ++ff=dos
```

#### CR(Mac)
```vim
:e ++ff=mac
```

### 指定する
```vim
:se ff=unix
:se ff=dos
:se ff=mac
```

## ctags
Ctagsは今でも更新されている `universal-ctags` を使用する。

### インデックスファイルの作成

```bash
$ ctags -R -f tags
```

### Vimの設定

```vim
:set tags=tags
```

### タグジャンプ

|key|動作|
|:--|:--|
|Ctrl+]|タグジャンプ|
|Ctrl+t|元に戻る|
|Ctrl+x Ctrl+]|タグリスト補間|

## vim-lsp
|key|動作|
|:--|:--|
|F12|定義ジャンプ|
|Ctrl+x Ctrl+]|宣言ジャンプ|
|Ctrl+t|元に戻る|
|Ctrl+]|シンボル情報|
|]e|次のエラー|

## LSPプラグインのインストール
### vim-plug
https://github.com/prabirshrestha/vim-lsp

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

上記のコマンドを実行する。

### vim-lsp-settings
https://github.com/mattn/vim-lsp-settings

#### プラグインのインストール
`.vimrc` に以下を記載する。
（上からLSP使用、自動補完、LSP設定のプラグイン）

```
call plug#begin()

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'

call plug#end()
```

vimを起動して以下を実行する。

1. `:` キーを押下
1. 続けて `PlugInstall` を実行

#### LSPのインストール
対応しているファイルを開くと `LspInstallServer` を実行するように表示されるので、
インストールする場合は以下を実行する。

1. `:` キーを押下
1. 続けて `LspInstallServer` を実行

表示されたウィンドウで行番号が表示されたらインストール完了です。
（インストール完了してもウィンドウは閉じないので、行番号表示を推奨）

## その他のプラグイン
### fern.vim
ファイルツリーを表示するプラグイン。 \
ショートカットキーは以下の通り。

|key|動作|
|:--|:--|
|j, k|上下に移動する|
|l|フォルダを展開する、ファイルを開く|
|h|フォルダを閉じる|
|e|ファイルを開く|
|E|垂直分割してファイルを開く|
|t|新規タブでファイルを開く|
|Ctrl+m|フォルダを開く|
|Ctrl+h|親ディレクトリに移動する|
|Ctrl+w, h|左のウィンドウに移動する|
|Ctrl+w, l|右のウィンドウに移動する|
|N|ファイルを新規作成する|
|K|ディレクトリを新規作成する|
|D|ファイルを削除する|
|m|ファイルを移動する|
|R|ファイル名を変更する|
|-|ファイルを選択する|
|C|ファイルをコピーする|
|P|ペーストする|
|M|ファイルをコピーし、ペーストした時に元のファイルを削除する|
|y|ファイルパスをコピーする|
|z|ファイル名に合わせてウィンドウ幅を広げる|
|!|隠しファイルを表示/非表示する|
|/|名前を検索する|

※ファイルの削除には `$ sudo apt install trash-cli` を実行しておく必要がある。
