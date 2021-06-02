#
# 管理者権限でPSを実行し、以下のコマンドレットを実行する必要がある。
# > Set-ExecutionPolicy RemoteSigned -Scope Process
#

# add-type
Add-type -AssemblyName System.Web

# path
$ENV:PATH += ";C`:\files\bin"

# alias
Set-Alias -name xyz -Value "C:\Files\xyzzy\xyzzycli.exe"

# variable
$Projects = "c:\files\work\projects\"
$Memo = "C:\Files\work\Memo"
$Nippou = $Memo + "\日報"

# function

<#
	.SYNOPSIS
	PowerShellのプロファイル編集

	.DESCRIPTION
	指定のエディタで、PowerShellのプロファイルを開きます。
#>
function edit_profile
{
#    notepad $profile
    xyz $profile
}

<#
	.SYNOPSIS
	PowerShellの履歴ファイル編集

	.DESCRIPTION
	指定のエディタで、PowerShellの履歴ファイルを開きます。
#>
function edit_history
{
#    notepad (Get-PSReadLineOption).HistorySavePath
    xyz (Get-PSReadLineOption).HistorySavePath
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
    cd $path
}

<#
	.SYNOPSIS
	管理者として実行

	.DESCRIPTION
	指定のアプリケーションを管理者として実行します。
	(Windows PowerShell専用)
#>
function Win-sudo($Program, $Argument)
{
    if ($Argument -eq $null) {
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
	(Windows PowerShell専用)
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
	(Windows PowerShell専用)
#>
function Trash-Item
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
#>
function Generate-Password($len, $opt = 2)
{
	[System.Web.Security.Membership]::GeneratePassword($len, $opt)
}

