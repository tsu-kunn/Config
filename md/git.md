# .gitconfig

Gitの設定ファイル。\
GUIツールでも参照されるので必ず設定する必要がある。

- global
  - ~/.gitconfig (ホームディレクトリ直下)
- local
  - Project root/.git/gitconfig (Gitリポジトリ内)

優先順位は「local > global」で、local がない場合は global の設定が使われる。\
設定方法の `--global` を  `--local` にすることで、local に設定される。


## ユーザー名とメールアドレス
```
[user]
	name = ユーザー名
	email = メールアドレス
```

コミットする際に使用されるユーザー名とメールアドレスの設定。\
これがないとコミットできないので必ず設定する。

### 設定方法
```
$ git config --global user.name 'ユーザー名'
$ git config --global user.email 'メールアドレス'
```

## 認証情報のキャッシュ
```
[credential]
	helper = manager
```

HTTPSの認証情報をキャッシュするかの設定。\
基本はOSが提供するパスワード管理の仕組みを使う。\
OSごとに設定方法が違うので、使用する場合はOSに合わせて調べてる。\
　⇒上記の設定はWindowsの場合


## プロキシ
```
[http]
	proxy = http://proxy.example.com:8080
[https]
	proxy = http://proxy.example.com:8080
```

プロキシを使用している場合は設定が必要。

### 設定方法
```
$ git config --global http.proxy http://proxy.example.com:8080
$ git config --global https.proxy http://proxy.example.com:8080
```


## 文字色
```
[color]
	ui = true
```

`git status` や `git diff` で色分けするための設定。\

### 設定方法
```
$ git config --global color.ui true
```


## 改行コードの自動変換
```
[core]
	autocrlf = false
```

OSに応じて改行コードを変換する機能があるが、
Windows/macOS/Linuxが混在した環境で開発するときはトラブルの原因になるのでオフにするのが良い。

### 設定方法
```
$ git config --global core.autocrlf false
```


## 日本語ファイル名のエンコード
```
[core]
	quotepath = false
```

有効にすると日本語ファイル名がエンコードされて見づらくなるのでオフがおすすめ。\
　⇒エンコードされると文字コードの数字表示になる

### 設定方法
```
$ git config --global core.quotepath false
```


## エディター
```
[core]
	editor = vim
```

自動マージの際など、入力処理が発生した場合に使用されるエディターを設定する。\
デフォルトは vi らしい。

### 設定方法
```
$ git config --global core.editor vim
```

### .gitignoreの設定
```
[core]
	excludesfile = "${HOME}/.gitignore"
```

プロジェクトごとではなく、全体で適用したい場合に設定。


### 設定方法
```
$ git config --global core.excludesfile ~/.gitignore
```


## エイリアス
```
[alias]
	co = checkout
	st = status
	br = branch
	cm = commit
	fe = fetch
	oneline = "log --date=format:'%y-%m-%d %H:%M' --pretty=format:'%C(yellow)%h%C(reset) %ad %C(green)%an%C(red)%d%C(reset) : %s'"
	graph = "log --date=format:'%y-%m-%d %H:%M' --pretty=format:'%C(yellow)%h%C(reset) %ad %C(green)%an%C(red)%d%C(reset) : %s' --graph"
	sgraph = "log --date=format:'%y-%m-%d %H:%M' --pretty=format:'%C(yellow)%h%C(reset) %ad %C(green)%an%C(red)%d%C(reset) : %s' --graph --stat"
	numstat = "log --date=format:'%y-%m-%d %H:%M' --pretty=format:'%C(yellow)%h%C(reset) %ad %C(green)%an%C(red)%d%C(reset) : %s' --numstat"
	gone = "log --graph --oneline"
	gsa = "log --graph --stat --all"
```

頻繁に使う設定を短縮するなどに使用。

### 設定方法
```
$ git config --global alias.エイリアス名 コマンド名
```

例)
```
$ git config --global alias.cm commit
```


## diffの改善
```
git config --global diff.compactionHeuristic true
```

diffの表示が標準より賢くなる…らしい。


# .gitignore

Gitのファイル管理から除外したいファイルやディレクトリを設定する。\
OSが自動で作るファイルや中間ファイルなどを設定する。

## 設定例
```
# 中間ファイル
*.o
*.out
*.obj
*.log
*.tlog
tags

# VisualStudioの自動生成ファイル
*.suo
*.sdf
*.vcxproj.user

# その他不要ファイル
.DS_Store
Thumbs.db

# 特定フォルダを無視
/.svn
/binary
/node_modules
/build
```

# GitHub

GitHubで役に立ったメモを残す。

## リリースの取り消し
1. `git push --delete origin 削除するタグ名` でTagを削除
1. GitHubの対象リリースがDraftになるので、それを破棄する


# その他
## Git for Windows のアップデート
```Bash
$ git update-git-for-windows
```

## ローカルブランチとリモートブランチの対応付け
```bash
$ git pull origin
You asked to pull from the remote 'origin', but did not specify
a branch. Because this is not the default configured remote
for your current branch, you must specify a branch on the command line.
```

このエラーが出た場合は下記の操作を行う。

```bash
$ git branch --set-upstream-to=origin/ブランチ名
```

## 現在のブランチを同じ名前でリモートにpush
```bash
fatal: The current branch chore/logdir has no upstream branch.
To push the current branch and set the remote as upstream, use
```

このエラーを出さないように、自動で現在のブランチを同じ名前でリモートに push できるようにする。

```bash
$ git config --global push.default current
```

## ログ検索
### コミットメッセージから検索
```bash
$ git log --greap="検索文字列"
```

### コミットした名前とメールアドレスから検索
```bash
$ git log --author="検索文字列"
```

### 日付で検索
```bash
$ git log --since 日付(yyyy/mm/dd)
$ git log --since 開始の日付 --until 終了の日付
```

### ファイル名で検索
```bash
$ git log "ファイル名"
$ git log "ファイル名1" "ファイル名2"   # ファイル1と2を変更したコミットを表示
```

### ハッシュ値で検索
```bash
$ git log ハッシュ値 -1 # 指定したハッシュ値のコミットから1件分表示
```

## 変更の取り消し
### ファイル単位
```bash
$ git checkout ファイル名
```

### コミット単位
```bash
$ git reset --soft HEAD # 変更部分は残す
$ git reest --hard HEAD # 全て戻す
$ git checkout .        # 同上
```

### addの取り消し
```bash
$ git reset HEAD .
$ git reset HEAD ファイル名
```

## ローカルブランチのプッシュ
エラーメッセージに書かれている通りでよい。

```bash
$ git push -u origin <ブランチ名>
```

## バイナリの競合
マージでバイナリファイルが競合した場合、マージ元にあったファイルが残る。\
マージ元を採用する場合はそのままコミットすればよい。

### マージ先を採用する場合
```bash
$ git checkout --theirs ファイル名
```

### 競合したファイルの確認
```bash
$ git ls-files -u
````

### 特定のコミットまでマージ
`pull` は `fetch` と `marge` のコマンドを実行しているだけなので個別に実行すればよい。

```bash
$ git fetch origin
$ git marge ハッシュ値
```

## rename(git mv)前のログの確認
```bash
$ git log --follow ファイル名
```

