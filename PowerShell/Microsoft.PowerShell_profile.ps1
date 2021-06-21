#
# �Ǘ��Ҍ�����PS�����s���A�ȉ��̃R�}���h���b�g�����s����K�v������B
# > Set-ExecutionPolicy RemoteSigned -Scope Process
#

# add-type
Add-type -AssemblyName System.Web

# path
$ENV:PATH += ";C`:\files\bin"

# alias
Set-Alias -name editer -Value "code"

# variable
$Projects = "c:\files\work\projects\"
$Memo = "C:\Files\work\Memo"

# function

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
	(Windows PowerShell��p)
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
	(Windows PowerShell��p)
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
	(Windows PowerShell��p)
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
	�w��̃t�@�C�����ŐV�K�����t�@�C�����J���B
	�w�肪�Ȃ��ꍇ�� "yyyymmddhhmmss" �ŐV�K�����t�@�C�����J��
#>
function memow
{
	$FNAME = $Memo + "\"

	if ($args.length -eq 0) {
		$FNAME += (Get-Date).ToString("yyyyMMddHHmmss")
	} else {
		$FNAME += $args[0]
	}

	Write-Output ([System.IO.Path]::GetExtension($FNAME))

	if ([System.IO.Path]::GetExtension($FNAME) -eq "") {
		$FNAME += ".md"
	}

	editer $FNAME
}
