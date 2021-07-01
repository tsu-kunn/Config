#
# 管理者権限でPSを実行し、以下のコマンドレットを実行する必要がある。
# > Set-ExecutionPolicy RemoteSigned -Scope Process
#

# add-type
Add-type -AssemblyName System.Web

# ($PSVersionTable.Platform -eq "Unix") は PowerShell 6.0 から対応
if ([Environment]::OSVersion.Platform -ne "Win32NT") {
	# alias
	Set-Alias -name editer -Value "vim"

	# variable
	$Projects = "${HOME}/GitHub"
	$Memo = "${HOME}/GitHub/Config/md"
} else {
	# path
	$ENV:PATH += ";C:\Program Files\Git\usr\bin;C`:\files\bin;"

	# alias
	Set-Alias -name editer -Value "code"

	# variable
	$Projects = "c:\files\work\projects\"
	$Memo = "C:\Files\work\Memo"
}

# bash風のtab補完
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# キーバインドをEmacs風に変更
Set-PSReadLineOption -EditMode Emacs

# ビープ音をオフ
Set-PSReadlineOption -BellStyle None


# function

<#
	.SYNOPSIS
	PowerShellのプロンプト変更

	.DESCRIPTION
	プロンプトをBash風に表示する。
#>
function prompt
{
	Write-Host "PS " -ForegroundColor "DarkYellow" -nonewline

	if ([Environment]::OSVersion.Platform -ne "Win32NT") {
		$PC = [Environment]::MachineName
		Write-Host "$env:USER@${PC}:" -ForegroundColor "DarkGreen" -nonewline
	} else {
		Write-Host "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor "DarkGreen" -nonewline
	}

	Write-Host ":$(Split-Path (Get-Location) -Leaf)" -ForegroundColor "DarkCyan" -nonewline
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
#>
function win_sudo($Program, $Argument)
{
    if ($null -eq $Argument) {
        Start-Process $Program -Verb runas
    }
    else {
        Start-Process $Program -Verb runas $Argument
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
	.NetFrameworkのAPIを使ってランダムなパスワードを生成します。
	引数で長さを指定できます。
	(Windows PowerShell専用)
#>
function New-Password($len, $opt = 2)
{
	[System.Web.Security.Membership]::GeneratePassword($len, $opt)
}

<#
	.SYNOPSIS
	Webヘルプの表示

	.DESCRIPTION
	指定コマンドのWebヘルプを表示します。
#>
function manweb {
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
		$FName += ".md"
	}

	editer $FName
}

<#
	.SYNOPSIS
	バックアップアーカイブを作成

	.DESCRIPTION
	第一引数の名前 + "yyyyMMddHHmmss" でアーカイブを作成します。
	複数指定する場合はスペースで区切ってください。
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
		Compress-Archive -Path $args[0..$args.Length] -DestinationPath $FName -Force
	}
}
