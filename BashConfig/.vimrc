" .vimrc byT.A

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
"タイトルをウインドウ枠に表示しない
set notitle

" ステータスラインの設定
" Set the statusline
set statusline=%f               " filename relative to current $PWD
set statusline+=%h              " help file flag
set statusline+=%m              " modified flag
set statusline+=%r              " readonly flag
set statusline+=\ [%{&ff}]      " Fileformat [unix]/[dos] etc...
set statusline+=[ENC=%{&fileencoding}]  " File encoding
set statusline+=[%Y]            " Filetype
set statusline+=%=              " Rest: right align
set statusline+=%l,%c%V         " Position in buffer: linenumber, column, virtual column
set statusline+=\ %P            " Position in buffer: Percentage

"ステータスラインを表示（0:非表示 1:2つ以上 2:常時）
set laststatus=2

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
" <C-N>の補完を<C-I>に割り当て
inoremap <C-I> <C-N>

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

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

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

