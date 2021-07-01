# PowerShell メモ

Windows PowerShell と PowerShell を使用する際のメモ。

## スクリプト置き場
[Config/PowerShell](https://github.com/tsu-kunn/Config/tree/master/PowerShell)

## メモ
### スクリプトの実行を有効にする
管理者権限でPSを実行し、以下のコマンドレットを実行する必要がある。

```PowerShell
> Set-ExecutionPolicy RemoteSigned -Scope Process
```

### プロファイルの場所
`$profile` に配置される。\
自動で作成はされないので、手動で作成する必要がある。

```PowerShell
> new-item -path $profile -itemtype file -force
```


### Bash風の設定
```PowerShell
# bash風のtab補完
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# キーバインドをEmacs風に変更
Set-PSReadLineOption -EditMode Emacs
```

`-EditMode` には `Windows`, `Emacs`, `Vi` が設定できる。（default: Windows)

#### 番外: コマンドプロンプトのVim
- [Vim — KaoriYa](https://www.kaoriya.net/software/vim/)

または環境変数に以下のパスを通す。

```PowerShell
> $env:Path += ";C:\Program Files\Git\usr\bin"
```

### シンボリックリンク
管理者権限で起動する必要あり。

#### コマンドプロンプト
```
> mklink リンク名 ターゲット名
> mklink /D フォルダ名 ターゲットフォルダ名
```

#### PowerShell
```PowerShell
> New-Item -Value 'リンク名' -Path 'ターゲット名'  -ItemType SymbolicLink
> New-Item -Value 'フォルダ名' -Path 'ターゲットフォルダ名'  -ItemType SymbolicLink
```

#### 補足
`ItemType` には `Junction`, `HardLink` も設定することができる。


## スクリプト
### 比較演算子
|比較演算子|動作|
|:--|:--|
|-eq|=|
|-ne|!=|
|-gt|>|
|-ge|>=|
|-lt|<|
|-le|<=|
|-like|ワイルドカードと等しい|
|-nolike|ワイルドカードと等しくない|
|-match|正規表現と等しい|
|-nomatch|正規表現と等しくない|

### ダブルクォーテーション内での配列型変数の展開
- NG
  ```
  > $FName = "`"$a[0]_${Date}.zip`""
  ```
- OK
  ```
  > $FName = "`"$($a[0])_${Date}.zip`""
  ```

`$a[0]` や `${a[0]}` や `${a}[0]` では期待した展開にならない。\
`$()` でくくると期待した動作になる。

※Sub-Expression Operator といって、$()内部を先に評価してから式の評価を行うようになる。


## Web
- [PowerShell](https://github.com/PowerShell/PowerShell)
- [PowerShell ドキュメント](https://docs.microsoft.com/ja-jp/powershell/)
- [PowerShell Core入門 - 基本コマンドの使い方｜連載一覧｜](https://news.mynavi.jp/itsearch/series/devsoft/powershell_core_-.html)

