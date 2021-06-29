#!/etc/bash

# PATH
export LANG='ja_JP.UTF-8'
export PROMPT_DIRTRIM=3
export PATH=$PATH:"${HOME}/bin":

# history
export HISTSIZE=1000
export HISTCONTROL=ignoredups

# function
# cmd output SJIS->UTF-8
function wincmd()
{
	CMD=$1
	shift
	$CMD $* 2>&1 | iconv -f cp932 -t utf-8
}

function memow()
{
	FN=$(date +"%Y%m")

	if [ "$1" != "" ]; then
		FN=$1
	fi

	NDIR="${HOME}/GitHub/Config/md/$FN"
	EXT=$(basename $NDIR)
	EXT=${EXT##*.}

	if [ "$FN" = "$EXT" ]; then
		NDIR="${NDIR}.txt"
	fi

	vim "$NDIR"
}

function baktar()
{
	# ファイル名設定
	DATA=`date '+%Y%m%d_%k%M'`

	# 引数のチェック
	if [ $# -eq 0 -o "$1" = "-h" ]; then
		printf "baktar [option] [dirname]\n"
		printf "\n"
		printf "[option]\n"
		printf "  -h      : Help\n"
		printf "\n"
		printf "[dirname]\n"
		printf "  directory name\n"
		printf "\n"
	else
		FNAME=$(basename "$1")"_${DATA}.tar.gz"
		tar cvzf "$FNAME" "$@"
	fi
}


# alias
alias la='ls -a'
alias lla='ls -al'
alias grep='grep --color=auto'
alias diff='diff -u'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias bashrc='source ~/.bashrc'
alias bash_profile='source ~/.bash_profile'

alias proj='. proj.sh'
alias nip="memow $(date +"%Y%m")"

# prompt
# \w full path \W current path
export PS1='\[\e[00;32m\]\u@\H\[\e[00;34m\]:\w \$\[\e[00m\] '

# Git Bash only
alias python='winpty python'
alias docker='winpty docker'
alias npm='winpty npm'

