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
  if ([Environment]::OSVersion.Platform -eq "Win32NT") {...}
  ```
- PowerShell 6.0～
  ```PowerShell
  if ($PSVersionTable.Platform -eq "Win32NT") {...}
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
> New-Item -Path 'リンク名' -Value 'ターゲット名' -ItemType SymbolicLink
> New-Item -Path 'フォルダ名' -Value 'ターゲットフォルダ名' -ItemType SymbolicLink
```

#### 補足1
`ItemType` には `Junction`, `HardLink` も設定することができる。

#### 補足2
コマンドプロンプトでmklinkを実行する。\
引数は `"..."` で囲む必要がある。

```
> Start-Process cmd -Verb runas -ArgumentList "/c mklink /d c:\files\work\projects\Memo c:\files\work\Memo"
or
> win_sudo cmd "/c mklink /d c:\files\work\projects\Memo c:\files\work\Memo"
```

### 一時ディレクトリ
`Temp:`

有効になっていない場合は以下のコマンドを実行する。

```PowerShell
> Enable-ExperimentalFeature -Name PSTempDrive
```

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
|-contains|参照値がコレクションに含まれている|
|-notcontains|参照値がコレクションに含まれていない|
|-in|テスト値がコレクションに含まれている|
|-notin|テスト値がコレクションに含まれていない|
|-replace|文字列パターンを入れ替え(大文字と小文字の区別なし)|
|-creplace|文字列パターンを入れ替え(大文字と小文字の区別あり)|
|-is|オブジェクトの双方の型が等しい|
|-isnot|オブジェクトの双方の型が等しくない|

### 算術演算子
|算術演算子|動作|
|:--|:--|
|+|加算・結合|
|-|減算|
|*|乗算|
|/|除算|
|%|剰余算|
|-band|ビットAND|
|-bnot|ビットNOT|
|-bor|ビットOR|
|-bxor|ビットXOR|
|-shl|左へビットシフト|
|-shr|右へビットシフト|

### リダイレクト
|演算子|動作|
|:--|:--|
|>|ファイルへ書き込み|
|>>|ファイルへ追記|
|>&n|ストリームn へリダイレクト|
|> $null|Bashの `> /dev/null` と同様|

|ストリーム番号|内容|
|:--|:--|
|1|サクセスストリーム|
|2|エラーストリーム|
|3|ワーニングストリーム|
|4|冗長ストリーミング|
|5|デバッグストリーム|
|6|インフォメーションストリーム|
|*|すべてのストリーム|

### 正規表現
|表現|動作|
|:--|:--|
|.|任意の1文字|
|^|行頭|
|$|行末|
|\文字|エスケープ|
|[文字列]|ブランケット内の1文字に一致|
|[^文字列]|ブランケット内に存在しない1文字に一致|
|[始-終]|範囲指定でのブランケット|
|\w|文字に一致|
|\W|文字以外に一致|
|\s|ホワイトスペースに一致|
|\S|ホワイトスペース以外に一致|
|\d|数字に一致|
|\D|数字以外に一致|
|?|0回または1回の繰り返し|
|*|0回以上の繰り返し|
|+|1回以上の繰り返し|
|{n}|n回繰り返し|
|{n,}|n回以上繰り返し|
|{n,m}|n回以上m回以下繰り返し|

### PowerShellGet
- バージョンの確認
  ```PowerShell
  > Get-Command -Module PowerShellGet
  ```
- モジュールの検索
  - [PowerShell Gallery](https://www.powershellgallery.com/)
- インストール
  ```PowerShell
  > Install-Module [モジュール名]
  ```
- アップデート
  ```PowerShell
  > Update-Module
  ```

## スクリプト

### 関数名
関数名は「動詞 - 名詞」の組み合わせが推奨されている。(VSCodeのPowerShell拡張で指摘される)\
組み合わせは [PowerShell コマンドに承認されている動詞](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.1) を参照。

### Windows/macOS/Linuxで動作させる
スクリプトファイルの先頭に以下を記載する。\
```PowerShell
#!/usr/bin/env pwsh
```

### バッチファイルから管理者権限を変更して実行
権限を一時的に変更しているので戻す操作不要。\
PowerShellの権限を変更していない環境で有効。

```
powershell -sta -ExecutionPolicy Unrestricted -File %0\..\[スクリプト名].ps1
```

### 終了コード
exit の終了コードは `$LASTEXITCODE` に保存される。

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

### 自動変数
- `$^`
  - 前回実行した1番目の文字列
- `$$`
  - 前回実行した最後の文字列
- `$_`
  - 現在のオブジェクト
- `$?`
  - 前回のコマンド実行結果
- `$Args`
  - 引数
- $NULL
- $True
- $False

### 出力を破棄
パイプに `out-null` を指定する。

例) mkdir tmp | out-null


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

### パイプラインチェイン(7.0以上)
- コマンド1 && コマンド2
  - コマンド1が正常終了するとコマンド2が実行される。
- コマンド1 || コマンド2
  - コマンド1が異常終了するとコマンド2が実行される。

※if文と $?(直前の式の結果) の組み合わせの代替処理

### Null演算子
- Null合体演算子
  - 変数 ?? 値
    - 変数の値が $null なら値を使用する。
- Null合体代入演算子
  - 変数 ??= 値
    - 変数の値が $null なら値を代入する。
- Null条件演算子
  - 変数?
    - 変数の値が $null なら以降を実行しない。
    - 例）`${f}?.OpenText()?.ReadToEnd()`

### JSONファイル編集
```PowerShell
# JSON読み込み
$JsonData = Get-Content -Path .\json_test.json
$ObjectData = $JsonData | ConvertFrom-Json

# JSONの表示
Write-Host $ObjectData.num_list
Write-Host $ObjectData.user_info

Write-Host $ObjectData.num_list[3]
Write-Host $ObjectData.user_info[0]

Write-Output $ObjectData[0].name
Write-Output $ObjectData[0].age
Write-Output $ObjectData[2].user_info.user_name

# JSONの追加
$ObjectData[2] | Add-Member -NotePropertyName "name" -NotePropertyValue "Miku"
$ObjectData[2] | Add-Member -NotePropertyMembers @{test_info=@{test_id="0000"; test_name="Test Name"}}
$ObjectData[2] | Add-Member -NotePropertyName "color list" -NotePropertyValue @("red", "green", "blue")
$ObjectData += @(@{user_info=@{user_id="DEF456"; user_name="Miyuki"}})

# JSON保存
$JsonData = $ObjectData | ConvertTo-Json
Set-Content -path json_test_output.json -Value $JsonData
```

#### 補足
`ConvertTo-Json` と　`ConvertFrom-Json` でネストが深いと変換されないことがある。\
その場合はオプションの `-Depth` でネストの深さを設定する。(default:2)

### XMLファイル編集
```PowerShell
# XMLファイル読み込み
[xml]$XmlData = Get-Content ".\test_xml.xml"

# ノードへアクセス
Write-Output $XmlData.HEADER.LIST.STRING
Write-Output $XmlData.HEADER.BODY.ID
Write-Output $XmlData.HEADER.BODY.NAME

# ノード作成
$xmlNode = $XmlData.CreateNode("element", "pages", "")

# ノードデータ設定
$xmlNode.InnerText = "add text"

# ノード追加
$XmlData.DocumentElement.AppendChild($xmlNode) > $null

# XMLファイル保存
$XmlData.Save("$pwd\test_xml_output.xml")

# 追加を確認
Write-Output $xmlData.HEADER.pages
```

#### 補足
`ConvertTo-Xml` はあるけど `ConvertFrom-Xml` はないので.NETの機能を使う必要がある。\
JSONファイルをXMLファイル出力とかはできるんだけどね。


### パイプライン入力
#### 自動変数で受け取る
- `$input` オブジェクトから読み取る
  - `$input.Name` といった感じでプロパティを指定して使う
- `$PSItem` オブジェクトから読み取る
  - `process {...}` ブロック内で使用可能
  - 引数で値を渡した場合は値がない

#### 変数で受け取る
パラメーターの `ValueFromPipeline` 属性を有効にする。\
引数とパイプライン両方で値を受け取ることが可能になる。（配列もOK）

```PowerShell
param ([Parameter(ValueFromPipeline=$true)]$str)
```

#### begin/process/end ブロック
`$input` 以外でパイプライン入力を受け取る場合は `process` ブロックが必要。\
`begin`, `end` は省略可能。

``` PowerShell
begin {
    初期化処理
}
process {
    メイン処理（必須）
}
end {
    終了処理
}
```

#### $inputで受け取る
`$input` には単数ではなく複数渡される場合があるのでそれに対応する必要がある。

```PowerShell
if (-Not $args) {
    # パイプライン
    foreach ($i in $input) {
        ～処理～
    }
} else {
    # 引数
    ～処理～
}
```


## 覚えるべきコマンドレット
|コマンドレット|alias|動作|
|:--|:--|:--|
|Get-ChildItem|dir|ファイルとディレクトリの表示|
|Select-String|sls|対象から指定の文字列を検索|
|Out-String -Stream|oss|オブジェクトをテキストとして表示|
|Get-Content|type|ファイルの中身を表示|
|Show-Markdown|-|Markdownテキストの表示|
|ConvertFrom-Markdown|-|Markdownからオブジェクトに変換|
|Write-Output|echo|オブジェクトをパイプラインに出力|
|Write-Host|-|コンソールに文字を表示|
|Clear-Host|clear|コンソール表示の消去|
|New-Item|ni|ファイルやディレクトリを作成|
|Invoke-Item|ii|ファイルを実行|

## パイプラインで使用するコマンドレット
|コマンドレット|alias|動作|
|:--|:--|:--|
|Select-Object|select|特定のオブジェクトを選択|
|Where-Object|?|特定の条件を満たすデータを取得|
|Group-Object|group|同じプロパティをグループ化|
|ForEach-Object|%|入力オブジェクトの各アイテムに対して操作を実行|



## コマンド例
### 新規ファイル作成
```PowerShell
> New-Item -path ./hoge/temp/hoge.md -ItemType file -Force
```

※`-Force` を付けることでディレクトリを自動作成できる。

### 16進ダンプ
```PowerShell
> Format-Hex <ファイル名> | more
```

### ファイルとディレクトリの数とサイズ取得
```PowerShell
# 隠しファイル非対象
> Get-ChildItem -Recurse | Measure-Object Length -Maximum -Minimum -Average -Sum

# 隠しファイル対象
> Get-ChildItem -Recurse -Force | Measure-Object Length -Maximum -Minimum -Average -Sum
```

### JSONCをWindows PowerShellで読み込む場合の対応
```PowerShell
> $x = Get-Content -Path .\settings.json | Where-Object{ $_ -notmatch "^\s*//.*$" } | ConvertFrom-Json
```

### grepに近い動作
```PowerShell
> ls | oss | sls <条件or正規表現>
```

※`ls | sls` だと一覧に含まれるファイルの中まで検索してしまうので、`oss` でテキストにして渡す。

### Select-String のよく使うオプション
|オプション|動作|
|:--|:--|
|-SimpleMatch|正規表現を使用せずに検索|
|-NotMatch|一致しない行を表示|
|-Contex 行数|一致した前後を行数分表示|
|-CaseSensitive|大文字と小文字を区別|

### 進数変換
#### 10進数から変換
```PowerShell
# 2進数
> [Convert]::ToString(<値>, 2)
# 16進数
> [Convert]::ToString(<値>, 16)
```

#### 2, 16進数から変換
```PowerShell
# 2進数
> [Convert]::ToInt32(<2進数>, 2)
# 16進数
> [Convert]::ToInt32(<16進数>, 16)
```

### 時間・日数計算
```PowerShell
# 8時間前
> (Get-Date).AddHours(-8)
# 30日後
> (Get-Date).AddDays(30)
# 指定日から60日前
> ([DateTime]"2021/07/28").AddDays(-60)
```

### GUID
```PowerShell
> New-Guid
```

### 圧縮
#### Zip
```PowerShell
> compress-Archive -Path <File or Directory> -DestinationPath hoge.zip -Force
```

### tar
```PowerShell
> tar cvzf hoge.tar.gz [file/directory]
> tar cvjf hoge.tar.bz2 [file/directory]
```

### 7zip
別途 `7za.exe` が必要。

```PowerShell
> 7za a hoge.7z [file/directory]
> 7za a -tzip hoge.zip [file/directory]
```

### 解凍
#### Zip
```PowerShell
> Expand-Archive -Path hoge.zip -DestinationPath ./tmp
```

### tar
```PowerShell
> tar xvf hoge.tar.gz
> tar xvf hoge.tar.bz2
> tar xvg hoge.tar.gz -C ~/tmp
```

### 7zip
```PowerShell
> 7za x hoge.7z
> 7za x hoge.zip
> 7za x hoge.7z -otmp
```

### 日付のフォーマット指定
```PowerShell
> (Get-Date).ToString("yyyy/MM/dd")
```

`Get-Date` にカッコを付けないとエラーになる。\
括弧が必要な理由は、コマンドレットが完了してから返されるオブジェクトのメソッドにアクセスする必要があるから。\
`Get-Location` など同様の対応が必要なコマンドレットがある。

### 文字列処理パターン
|文字列処理|コマンド|
|:--|:--|
|置換|gc <入力ファイル> \| % { $_ -creplace "<検索文字列>", "<置換文字列>" }|
|空白を削除|gc <入力ファイル> \| ? { $_ -ne "" }|
|コメントを削除|gc <入力ファイル> \| ? { $_ -notmatch "^#" }|
|改行を削除|gc <入力ファイル> -Raw \| % { $_ -replace "`r`n", "" }|
|先頭に文字列追加|gc <入力ファイル> \| % { "<追加文字列>" + $_ }|

#### 参考
- [Windows標準コマンド (PowerShell) を使ってsedっぽいことを実現する](https://tech-mmmm.blogspot.com/2020/06/windowssed.html)

# Web
- [PowerShell](https://github.com/PowerShell/PowerShell)
- [PowerShell ドキュメント](https://docs.microsoft.com/ja-jp/powershell/)
- [PowerShell Core入門 - 基本コマンドの使い方｜連載一覧｜](https://news.mynavi.jp/itsearch/series/devsoft/powershell_core_-.html)
- [Windows にまつわる e.t.c.](https://www.vwnet.jp/Windows/etc.asp#PowerShell)


