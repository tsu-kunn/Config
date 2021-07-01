#
# �Ǘ��Ҍ�����PS�����s���A�ȉ��̃R�}���h���b�g�����s����K�v������B
# > Set-ExecutionPolicy RemoteSigned -Scope Process
#

# add-type
Add-type -AssemblyName System.Web

# ($PSVersionTable.Platform -eq "Unix") �� PowerShell 6.0 ����Ή�
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

# bash����tab�⊮
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# �L�[�o�C���h��Emacs���ɕύX
Set-PSReadLineOption -EditMode Emacs

# �r�[�v�����I�t
Set-PSReadlineOption -BellStyle None


# function

<#
	.SYNOPSIS
	PowerShell�̃v�����v�g�ύX

	.DESCRIPTION
	�v�����v�g��Bash���ɕ\������B
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
	PowerShell�̃v���t�@�C���ҏW

	.DESCRIPTION
	�w��̃G�f�B�^�ŁAPowerShell�̃v���t�@�C�����J���܂��B
#>
function Edit-Profile
{
#    notepad $profile
    editer $profile
}

<#
	.SYNOPSIS
	PowerShell�̗����t�@�C���ҏW

	.DESCRIPTION
	�w��̃G�f�B�^�ŁAPowerShell�̗����t�@�C�����J���܂��B
#>
function Edit-History
{
#    notepad (Get-PSReadLineOption).HistorySavePath
    editer (Get-PSReadLineOption).HistorySavePath
}

<#
	.SYNOPSIS
	projects�t�H���_�ֈړ�

	.DESCRIPTION
	���݂̃p�X��projects�t�H���_�ɕύX���܂��B
#>
function goto_projects($proj)
{
	$path = $Projects + $proj
    Set-Location $path
}

<#
	.SYNOPSIS
	�Ǘ��҂Ƃ��Ď��s

	.DESCRIPTION
	�w��̃A�v���P�[�V�������Ǘ��҂Ƃ��Ď��s���܂��B
	(Windows��p)
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
	Windows�̃o�[�W������OS�r���h���擾

	.DESCRIPTION
	���W�X�g������K�v�ȏ����擾���܂��B
	(Windows��p)
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
	�S�~���Ƀt�@�C����t�H���_���폜����

	.DESCRIPTION
	�V�F���̋@�\���g���ăS�~���֍폜���܂��B
	(Windows��p)
#>
function Remove-ItemToTrash
{
	if ($args.length -eq 0) {
		Write-Output "���ݔ��Ɏ̂Ă�t�@�C�����t�H���_���w�肵�Ă��������B"
		return
	}

	$shell = new-object -comobject Shell.Application;

	for ($i = 0; $i -lt $args.length; $i++) {
		# �w��A�C�e���̑��݊m�F
		$isPath = Test-Path $args[$i]
		if ($isPath -eq 0) {
			$msg = $args[$i] + " �����݂��܂���B"
			Write-Output $msg
			continue
		}

		# ���΃p�X���΃p�X�ɕϊ�
		# ���C���h�J�[�h�̏ꍇ�͔z�񂪕Ԃ�̂ŁA����ȊO�ł��z��ɂȂ�悤�ɂ���
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
	���݂̓������N���b�v�{�[�h�ɃR�s�[

	.DESCRIPTION
	���݂̓������N���b�v�{�[�h�ɃR�s�[���܂��B
	"-q"�ŕW���o�͂�}�����܂��B
#>
function Copy-DateAndTime($opt = "None")
{
	$NowDateTime = (Get-Date).ToString("yyyy�NMM��dd��(ddd) HH:mm")

	if ($opt -ne "-q") {
		Write-Output $NowDateTime
	}

	$NowDateTime | Set-Clipboard
}

<#
	.SYNOPSIS
	�����_���ȃp�X���[�h�쐬

	.DESCRIPTION
	.NetFramework��API���g���ă����_���ȃp�X���[�h�𐶐����܂��B
	�����Œ������w��ł��܂��B
	(Windows PowerShell��p)
#>
function New-Password($len, $opt = 2)
{
	[System.Web.Security.Membership]::GeneratePassword($len, $opt)
}

<#
	.SYNOPSIS
	Web�w���v�̕\��

	.DESCRIPTION
	�w��R�}���h��Web�w���v��\�����܂��B
#>
function manweb {
	Param(
		[String] $Command = 'Get-Help'
	)
	Get-Help $Command -Online
}

<#
	.SYNOPSIS
	�V�K�����t�@�C�����J��

	.DESCRIPTION
	�w��̃t�@�C�����ŐV�K�����t�@�C�����J���܂��B
	�w�肪�Ȃ��ꍇ�� "yyyymmddHH" �ŐV�K�����t�@�C�����J���܂��B
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
	�o�b�N�A�b�v�A�[�J�C�u���쐬

	.DESCRIPTION
	�������̖��O + "yyyyMMddHHmmss" �ŃA�[�J�C�u���쐬���܂��B
	�����w�肷��ꍇ�̓X�y�[�X�ŋ�؂��Ă��������B
#>
function bakarc
{
	# �����̃`�F�b�N
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
		# �t�@�C�����ݒ�
		$Date = (Get-Date).ToString("yyyyMMddHHmmss")
		$FName = (Get-Item $args[0]).BaseName + "_${Date}.zip"

		# ���k
		Compress-Archive -Path $args[0..$args.Length] -DestinationPath $FName -Force
	}
}
