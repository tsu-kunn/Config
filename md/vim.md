# Vim ショートカットキー

## ファイル
|key|動作|
|:--|:--|
|e file|file を開く|
|:q|終了|
|:!q|保存せずに終了|
|:wq or ZZ|保存して終了|
|:w|変更を保存|
|:w file|file という名前で保存|
|:set fileencoding=n|文字コードを n に設定|


## タブ
|key|動作|
|:--|:--|
|:tabe file|新しいタブで file を開く|
|:tabc|表示中のタブを閉じる|
|:tabn or gt|右隣のタブに移動|
|:tabN or gT|左隣のタブに移動|
|:taba|表示中以外のタブを閉じる|
|:tabs|タブ一覧|


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
|Ctrl+f|１画面上に移動|
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

## 検索
|key|動作|
|:--|:--|
|/ w|wを検索|
|*|カーソル位置の単語を検索|
|n or *|次の候補|
|N or #|前の候補|
|:%s/word/WORD/g|置換（wordをWORDに置換）|


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


# .vimrc設定例
```
"---------------------------------------------------------------
" 文字関係
"---------------------------------------------------------------
"カラー表示
syntax on

"デフォルトの文字コード
set encoding=utf-8

"自動判別
set fileencodings=utf-8,utf-16,cp932,iso-2022-jp,sjis

"○や□文字が崩れる問題を解決
set ambiwidth=double

"全角スペースの背景色を変更
autocmd Colorscheme * highlight FullWidthSpace ctermbg=0
autocmd VimEnter * match FullWidthSpace /　/

"カラースキームの設定(ron: Git BashのVim標準設定)
colorscheme ron

"スワップファイルを作成しない
set noswapfile

"---------------------------------------------------------------
" 表示関係
"---------------------------------------------------------------
"タイトルをウインドウ枠に表示する
set title

"行番号表示
set number

"ルーラーを表示 (noruler:非表示)
set ruler

"タブや改行を表示 (nolist:非表示)
set list

"行の折り返しを無効にする
set nowrap

"リストで表示される文字のフォーマットを指定する
set listchars=tab:>\ ,extends:<

"カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

"カーソル行のハイライト
set cursorline

"かっこの対応関係を表示する (%で対応かっこにジャンプ)
set showmatch
source $VIMRUNTIME/macros/matchit.vim

"矩形選択で文字がなくても右へ進める
set virtualedit=block

"---------------------------------------------------------------
" 編集関係
"---------------------------------------------------------------
"タブの画面上での幅
set tabstop=4

"タブをスペースに展開 (noexpandtab:展開しない)
set expandtab

"シフト移動幅
set shiftwidth=4

"連続した空白に対してカーソルが動く幅
set softtabstop=4

"自動的にインデントする (noautoindent:インデントしない)
set autoindent

"高度な自動インデントする
set smartindent

"バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
"set backspace=2

"括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch

"コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu

"テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"バッファを切替えてもundoの効力を失わない
set hidden

"補完設定(候補が1つでも表示, 選択しない限り挿入しない)
"※Ctrl+x, Ctrl+n/pで選択 Ctrl+yで確定
set completeopt=menuone,noinsert

"yでコピーした時にクリップボードに入る
set clipboard+=unnamed
set guioptions+=a

"---------------------------------------------------------------
" 検索関係
"---------------------------------------------------------------
"検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan

"検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

"インクリメンタル検索
set incsearch

"検索語をハイライト表示
set hlsearch

"ESC2回でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"vimgre/grep/Ggrepで自動的にquickfix-windowで開く
autocmd QuickFixCmdPost *grep* cwindow

"---------------------------------------------------------------
" キーマップの変更
"---------------------------------------------------------------
" 挿入とコマンドラインでカーソル周りをemacs風味にする
noremap! <C-D> <Del>
noremap! <C-F> <Right>
noremap! <C-B> <Left>
noremap! <C-P> <Up>
noremap! <C-N> <Down>
noremap! <C-A> <Home>
noremap! <C-E> <End>
noremap! <C-K> <Esc><Right>Da
noremap! <C-L> <Esc>zza

" 挿入モードでUndo/Redoを行えるようにする(Linux環境で不都合があるのでコメントアウト)
"inoremap <C-Z> <Esc>ua
"inoremap <C-Y> <Esc><C-r>a

" 挿入モードでCtrl+sを行えるようにする(Linux環境で不都合があるのでコメントアウト)
"inoremap <C-S> <Esc>:w<CR>a

" vimgrep 前:<F4>, 次:<F3>
nnoremap <F4> :cNext<CR>
nnoremap <F3> :cnext<CR>

"---------------------------------------------------------------
" オムニ補完設定
" ※Ctrl+x,Ctrl+oで候補を出す、Ctrl+n Ctrl+pで選択、Ctrl+yで確定 
"---------------------------------------------------------------
set omnifunc=ccomplete#Complete
set omnifunc=csscomplete#CompleteCSS
set omnifunc=htmlcomplete#CompleteTags
set omnifunc=javascriptcomplete#CompleteJS
set omnifunc=phpcomplete#CompletePHP
set omnifunc=pythoncomplete#Complete
set omnifunc=rubycomplete#Complete
set omnifunc=xmlcomplete#CompleteTags
set omnifunc=syntaxcomplete#Complete

"---------------------------------------------------------------
" クリップボードからのペーストはインデントしない
"---------------------------------------------------------------
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
```


# Vimメモ
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

