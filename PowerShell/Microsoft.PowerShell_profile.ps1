#
# 管理者権限でPSを実行し、以下のコマンドレットを実行する必要がある。
# > Set-ExecutionPolicy RemoteSigned -Force
#

# add-type
#Add-type -AssemblyName System.Web

# use posh-git
Import-Module posh-git

# ($PSVersionTable.Platform -eq "Unix") は PowerShell 6.0 から対応
if ([Environment]::OSVersion.Platform -eq "Win32NT") {
	# path
	$ENV:PATH = "C:\Program Files\OpenSSH;" + $ENV:PATH;
	$ENV:PATH += ";C:\Program Files\Git\usr\bin;${HOME}\bin;"

	# alias
	Set-Alias -name vi -Value "vim.exe"
	Set-Alias -name editer -Value "vim.exe"

	# variable
	$Projects = "${HOME}/GitHub/" 
	$Memo = "${HOME}/GitHub/Config/md"
	$Bext = ".md"
	$Div = "\\"

	# use linux command(Git Bash or WSL2)
	# Get-Alias diff *> $null && Remove-Item alias:diff -Force # ver.7.0～
	Get-Alias diff *> $null
	if ($?) {
		Remove-Item alias:diff -Force -ErrorAction Stop
	}

	function diff
	{
		diff.exe -u --color $args
		# wsl diff -u $args
	}

	function grep {
		# 簡易的な変換のみ実施
		$args[-1] = $args[-1].Replace('\', '/')
		$input | grep.exe --color=auto $args

		# windowsから呼び出すと'\'を'/'に変換できないので、'\\'に置き換えて実行
		# $args[-1] = wsl wslpath $args[-1].Replace('\', '\\')
		# $input | wsl grep --color=auto $args
	}

	# Git Bashのfindを指定
	Set-Alias -Name find -Value "C:\Program Files\Git\usr\bin\find.exe"
} else {
	# alias
	Set-Alias -name editer -Value "vim"

	# variable
	$Projects = "${HOME}/GitHub/"
	$Memo = "${HOME}/GitHub/Config/md"
	$Bext = ".md"
	$Div = "/"

	# Windowsの場合と表示を合わせる
	function diff
    {
		/usr/bin/diff -u --color $args
	}

	function grep
	{
		$input | /bin/grep --color=auto $args
	}
}

# bash風のtab補完
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# キーバインドをEmacs風に変更
Set-PSReadLineOption -EditMode Emacs

# ビープ音をオフ
Set-PSReadlineOption -BellStyle None

# 引数の色を変更する
Set-PSReadLineOption -Colors @{
    "Parameter" = [ConsoleColor]::DarkBlue
    #"Operator" = [ConsoleColor]::Gray
}

# 入力予測を有効にする(ver.7.2以前の場合設定）
#Set-PSReadLineOption -PredictionSource History

# function

<#
	.SYNOPSIS
	PowerShellのプロンプト変更

	.DESCRIPTION
	プロンプトをBash風に表示する。
#>
function prompt
{
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

<#
	.SYNOPSIS
	PowerShellのプロファイル編集

	.DESCRIPTION
	指定のエディタで、PowerShellのプロファイルを開きます。
#>
function Edit-Profile
{
#    notepad $profile
    editer $profile
}

<#
	.SYNOPSIS
	PowerShellの履歴ファイル編集

	.DESCRIPTION
	指定のエディタで、PowerShellの履歴ファイルを開きます。
#>
function Edit-History
{
#    notepad (Get-PSReadLineOption).HistorySavePath
    editer (Get-PSReadLineOption).HistorySavePath
}

<#
	.SYNOPSIS
	projectsフォルダへ移動

	.DESCRIPTION
	現在のパスをprojectsフォルダに変更します。
	（Bashと共通関数）

	.PARAMETER proj
	追加のプロジェクトパス。
#>
function goto_projects($proj)
{
	$path = $Projects + $proj
    Set-Location $path
}

<#
	.SYNOPSIS
	管理者として実行

	.DESCRIPTION
	指定のアプリケーションを管理者として実行します。
	(Windows専用)

	.PARAMETER Program
	管理者権限で実行するプログラム名

	.PARAMETER Argument
	プログラムへ渡す引数。
	複数指定する場合は "" で囲んでください。
#>
function win_sudo($Program, $Argument)
{
    if ($null -eq $Argument) {
        Start-Process $Program -Verb runas
    }
    else {
        Start-Process $Program -Verb runas -ArgumentList $Argument
    }
}

<#
	.SYNOPSIS
	WindowsのバージョンとOSビルドを取得

	.DESCRIPTION
	レジストリから必要な情報を取得します。
	(Windows専用)
#>
function Get-WindowsVersion
{
	$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $ReleaseID = (Get-ItemProperty -Path $RegPath -Name ReleaseId).ReleaseID
    $CurrentBuild = (Get-ItemProperty -Path $RegPath -Name CurrentBuild).CurrentBuild
    $UBR = (Get-ItemProperty -Path $RegPath -Name UBR).UBR

    "Version " + $ReleaseID + " (OS Build " + $CurrentBuild + "." + $UBR + ")"
}

<#
	.SYNOPSIS
	ゴミ箱にファイルやフォルダを削除する

	.DESCRIPTION
	シェルの機能を使ってゴミ箱へ削除します。
	(Windows専用)

	.PARAMETER
	ごみ箱に削除するファイル or ディレクトリ名。
	複数指定やワイルドカード指定ができます。
#>
function Remove-ItemToTrash
{
	if ($args.length -eq 0) {
		Write-Output "ごみ箱に捨てるファイルかフォルダを指定してください。"
		return
	}

	$shell = new-object -comobject Shell.Application;

	for ($i = 0; $i -lt $args.length; $i++) {
		# 指定アイテムの存在確認
		$isPath = Test-Path $args[$i]
		if ($isPath -eq 0) {
			$msg = $args[$i] + " が存在しません。"
			Write-Output $msg
			continue
		}

		# 相対パスを絶対パスに変換
		# ワイルドカードの場合は配列が返るので、それ以外でも配列になるようにする
		$path = @((Resolve-Path $args[$i]).Path)

		for ($j = 0; $j -lt $path.length; $j++) {
			$filename = [System.IO.Path]::GetFileName($path[$j])
			$dirname = [System.IO.Path]::GetDirectoryName($path[$j])

			$folder = $shell.Namespace($dirname)
			$item = $folder.ParseName($filename)

			$item.InvokeVerb("delete")
		}
	}

	$shell = $null
}

<#
	.SYNOPSIS
	現在の日時をクリップボードにコピー

	.DESCRIPTION
	現在の日時をクリップボードにコピーします。
	"-q"で標準出力を抑制します。
#>
function Copy-DateAndTime($opt = "None")
{
	$NowDateTime = (Get-Date).ToString("yyyy年MM月dd日(ddd) HH:mm")

	if ($opt -ne "-q") {
		Write-Output $NowDateTime
	}

	$NowDateTime | Set-Clipboard
}

<#
	.SYNOPSIS
	ランダムなパスワード作成

	.DESCRIPTION
	ランダムなパスワードを生成します。
	引数で長さを指定できます。

	.PARAMETER len
	パスワードの長さ(default:15)。
#>
function New-Password($len = 15)
{
	# https://www.reddit.com/r/PowerShell/comments/al2v1z/generate_good_password/

	$uppers = "ABCDEFGHJKLMNPQRSTUVWXYZ".ToCharArray()
	$lowers = "abcdefghijkmnopqrstuvwxyz".ToCharArray()
	$digits = "23456789".ToCharArray()
	$symbols = "_-+=@$%".ToCharArray()

	$chars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789_-+=@$%".ToCharArray()

	do {
		$pwdChars = "".ToCharArray()
		$goodPassword = $false
		$hasDigit = $false
		$hasSymbol = $false
		$pwdChars += (Get-Random -InputObject $uppers -Count 1)
		for ($i = 1; $i -lt $len; $i++) {
			$char = Get-Random -InputObject $chars -Count 1
			if ($digits -contains $char) { $hasDigit = $true }
			if ($symbols -contains $char) { $hasSymbol = $true }
			$pwdChars += $char
		}
		$pwdChars += (Get-Random -InputObject $lowers -Count 1)
		$password = $pwdChars -join ""
		$goodPassword = $hasDigit -and $hasSymbol
	} until ($goodPassword)

	Write-Output $password
}

<#
	.SYNOPSIS
	Webヘルプの表示

	.DESCRIPTION
	指定コマンドのWebヘルプを表示します。
#>
function manweb
{
	Param(
		[String] $Command = 'Get-Help'
	)
	Get-Help $Command -Online
}

<#
	.SYNOPSIS
	新規メモファイルを開く

	.DESCRIPTION
	指定のファイル名で新規メモファイルを開きます。
	指定がない場合は "yyyymmddHH" で新規メモファイルを開きます。
	（Bashと共通関数）
#>
function memow
{
	$FName = $Memo + "\"

	if ($args.length -eq 0) {
		# $FName += (Get-Date).ToString("yyyyMMddHHmmss")
		$FName += (Get-Date).ToString("yyyyMMddHH")
	} else {
		$FName += $args[0]
	}

	if ([System.IO.Path]::GetExtension($FName) -eq "") {
		$FName += $Bext
	}

	editer $FName
}

<#
	.SYNOPSIS
	日報ファイルを開く

	.DESCRIPTION
	（Bash aliasの対応）
#>
function nip
{
	$date = (Get-Date).ToString("yyyyMM")
	memow "日報/$date"
}

<#
	.SYNOPSIS
	バックアップアーカイブを作成

	.DESCRIPTION
	第一引数の名前 + "yyyyMMddHHmmss" でアーカイブを作成します。
	複数指定する場合はスペースで区切ってください。
	（Bashと共通関数）
#>
function bakarc
{
	# 引数のチェック
	if ($args.length -eq 0) {
        Write-Output "bakarc [option] [file/dirname]..."
        Write-Output ""
        Write-Output "[option]"
        Write-Output "  -h      : Help"
        Write-Output ""
		Write-Output "[file/dirname]"
		Write-Output "  file/directory name"
        Write-Output ""
	} else {
		# ファイル名設定
		$Date = (Get-Date).ToString("yyyyMMddHHmmss")
		$FName = (Get-Item $args[0]).BaseName + "_${Date}.zip"

		# 圧縮
		Compress-Archive -Path $args -DestinationPath $FName -Force
		# tar cvzf $FName $args
	}
}

<#
	.SYNOPSIS
	テキストファイルの比較

	.DESCRIPTION
	Compare-ObjectとSelect-ObjectとSort-Objectを使って、
	結果を見やすくしています。
#>
function comp
{
	Compare-Object @(Get-Content $args[0]) @(Get-Content $args[1]) |`
	  Select-Object -Property @{Name = 'ReadCount'; Expression = { $_.InputObject.ReadCount } }, * |`
	  Sort-Object -Property ReadCount
}

<#
	.SYNOPSIS
	文字列をURLエンコード

	.DESCRIPTION
	指定された文字列をURLエンコードします。
	パイプライン対応。
	（Bashと共通関数）
#>
function urlencode
{
	param ([Parameter(ValueFromPipeline=$true)]$str)

	process {
		[System.Web.HttpUtility]::UrlEncode($str)
	}
}

<#
	.SYNOPSIS
	URLエンコードを文字列にデコード

	.DESCRIPTION
	指定されたURLエンコードを文字列にデコードします。
	パイプライン対応。
	（Bashと共通関数）
#>
function urldecode
{
	param ([Parameter(ValueFromPipeline = $true)]$str)

	process {
		[System.Web.HttpUtility]::UrlDecode($str)
	}
}
