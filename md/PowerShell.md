# PowerShell メモ

Windows PowerShell と PowerShell を使用する際のメモ。

## スクリプト置き場
[Config/PowerShell](https://github.com/tsu-kunn/Config/tree/master/PowerShell)

## メモ
### スクリプトの実行を有効にする
管理者権限でPSを実行し、以下のコマンドレットを実行する必要がある。

```PowerShell
> Set-ExecutionPolicy RemoteSigned -Force
```

### プロファイルの場所
`$profile` に配置される。\
自動で作成はされないので、手動で作成する必要がある。

```PowerShell
> new-item -path $profile -itemtype file -force
```

### PowerShellのバージョン確認
```PowerShell
> $PSVersionTable
```

### OSの確認
- Windows PowerShellも対象
  ```PowerShell
  if ([Environment]::OSVersion.Platform -ne "Win32NT") {...}
  ```
- PowerShell 6.0～
  ```PowerShell
  if ($PSVersionTable.Platform -ne "Win32NT") {...}
  ```

OSは `Win32NT`, `MacOSX`, `Unix` がある。\
※Linux = Unix


### Gitなどで日本語が文字化けする
以下のコマンドを実行する。

```PowerShell
> Set-Item env:LANG -Value ja_JP.UTF-8
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

### 16進ダンプ
`Format-Hex <ファイル名> | more`

### プロンプトの変更
`function prompt` を作成する。\
最後に `return` を書かないと "PS>" が自動で表示される。

色を付けるには "Write-Host" の `-ForegroundColor` を利用する。

|値|色名|
|:--|:--|
|0|Black|
|1|DarkBlue|
|2|DarkGreen|
|3|DarkCyan|
|4|DarkRed|
|5|DarkMagenta|
|6|DarkYellow|
|7|Gray|
|8|DarkGray|
|9|Blue|
|10|Green|
|11|Cyan|
|12|Red|
|13|Magenta|
|14|Yellow|
|15|White|

例）Bash風
```PowerShell
function prompt
{
  if ([Environment]::OSVersion.Platform -eq "Win32NT") {
    $Div = "\\"
  } else {
    $Div = "/"
  }

  # trim directory
  $curPath = $(Get-Location).Path -split $Div
  $dirTrim = 3

  if ($curPath.Length -gt $dirTrim) {
    $s = $curPath.Length - $dirTrim
    $curPath = ".../" + $($curPath[$s..$curPath.Length] -join "/")
  } else {
    $curPath = $curPath -join "/"
  }

  # Window Title
  $Host.ui.RawUI.WindowTitle = "PS: $curPath"

  # prompt
  $PC = [Environment]::MachineName
  $UN = [Environment]::UserName

  Write-Host "PS " -ForegroundColor "DarkYellow" -nonewline
  Write-Host "${UN}@${PC}" -ForegroundColor "DarkGreen" -nonewline
  # Write-Host ":$(Split-Path (Get-Location) -Leaf)" -ForegroundColor "DarkCyan" -nonewline
  Write-Host ":$curPath" -ForegroundColor "DarkCyan" -nonewline
  return "> "
}
```

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

### ファイル名などの取得
- .NET関数を利用:
  - ファイル名（拡張子あり）:  `[System.IO.Path]::GetFileName()` 
  - ファイル名（拡張子なし）:  `[System.IO.Path]::GetFileNameWithoutExtension()` 
  - 拡張子:  `[System.IO.Path]::GetExtension()` 
  - ディレクトリ名:  `[System.IO.Path]::GetDirectoryName()` 
- Get-Itemを利用
  - ファイル名（拡張子あり）: `(Get-Item <File/Directory>).Name`
  - ファイル名（拡張子なし）: `(Get-Item <File/Directory>).BaseName`
  - 拡張子: `(Get-Item <File/Directory>).Extension`
  - ディレクトリ名: `(Get-Item <File/Directory>).DirectoryName`

※.NET関数は指定の名前がない場合は "" を返すが、Get-Itemではエラーとなる。


## 覚えるべきコマンドレット
|コマンドレット|alias|動作|
|:--|:--|:--|
|Get-ChildItem|dir|ファイルとディレクトリの表示|
|Select-String|sls|対象から指定もの時列を検索|
|Out-String -Stream|oss|オブジェクトをテキストとして表示|


## Web
- [PowerShell](https://github.com/PowerShell/PowerShell)
- [PowerShell ドキュメント](https://docs.microsoft.com/ja-jp/powershell/)
- [PowerShell Core入門 - 基本コマンドの使い方｜連載一覧｜](https://news.mynavi.jp/itsearch/series/devsoft/powershell_core_-.html)

