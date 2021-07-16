# WSL2のメモ

## インストール
コマンドラインはすべて管理者としてPowerShellを使用する。

### 1 - Linux 用 Windows サブシステムを有効にする
```PowerShell
> dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

### 2 - 仮想マシンの機能を有効にする
``` PowerShell
> dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

再起動を実施する。

### 3 - Linux カーネル更新プログラム パッケージをダウンロードする
[x64 マシン用 WSL2 Linux カーネル更新プログラム パッケージ](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi) をダウンロードし実行する。

### 4 - WSL 2 を既定のバージョンとして設定する
```PowerShell
> wsl --set-default-version 2
```

### 5 - Linux ディストリビューションをインストールする
Microsoft Store を開き、希望するLinuxディストリビューションをインストールする。\
Ubuntuの場合はLTSを推奨。（LTSなしは最新バージョンとなる）

- [Ubuntu](https://www.microsoft.com/ja-jp/p/ubuntu/9nblggh4msv6?activetab=pivot:overviewtab)
- [Ubuntu 20.04 LTS](https://www.microsoft.com/ja-jp/p/ubuntu-2004-lts/9n6svws3rx71?rtc=1&activetab=pivot:overviewtab)
- [Debian](https://www.microsoft.com/ja-jp/p/debian/9msvkqc78pk6?rtc=1&activetab=pivot:overviewtab)

### 6 - Windows Terminal をインストールする
必須ではないけど、利便性が向上するのでインストール推奨。\
インストール方法や使い方は [こちら](https://github.com/tsu-kunn/Config/blob/master/md/WindowsTerminal.md) を参照。

### 7 - 日本語化
#### ロケール
デフォルトでは英語ロケールなので、日本語ロケールに変更する。\
WSL2のBashから下記を実行する。

```bash
$ sudo apt install language-pack-ja
$ sudo update-locale LANG=ja_JP.UTF-8
```

#### man
```bash
$ sudo apt install manpages-ja manpages-ja-dev
```

## docker
### インストール
以下のコマンドを順番に実行していく。

```bash
$ sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && sync
$ wget -q https://download.docker.com/linux/debian/gpg -O - | sudo apt-key add -
apt-key fingerprint 0EBFCD88
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt update -y && sync
$ sudo apt install -y docker-ce docker-ce-cli containerd.io && sync
```

### サービス起動
```bash
$ sudo service docker start
```

### コンテナの実行
```bash
$  docker run -it -v $PWD/src:/home/node/src -w /home/node/src -p 3000:3000 -u node --name nodejs_14173 node:14.17.3 /bin/bash
```

- `-it` でホスト保持、入力可能になる
- `-v [ホストのディレクトリ]:[コンテナのディレクトリ]` でファイルを共有・永続化できる
- `-w [作業ディレクトリ]` で開始の作業ディレクトリを指定できる
- `-p [ホストのポート]:[コンテナのポート]` でマッピングができる
- `-u [コンテナのユーザー名]` でルート以外のユーザーにへこうできる
  - コンテナにユーザーを追加するにはイメージを作り直す必要あり

### 参考HP
- [Docker Documentation](https://docs.docker.com/)

## Docker Compose
※Proxy環境下の場合は `sudo -E` にする。

1. 以下のコマンドを実行して最新版をダウンロードする
  ```bash
  $ sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  ```

    - [最新版の確認](https://github.com/docker/compose/releases)
1. 実行権限の付与
  ```bash
  $ sudo chmod +x /usr/local/bin/docker-compose
  ```
1. コマンドライン補完をインストール
  ```bash
  $ sudo curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
  ```
1. インストールの確認
  ```bash
  $ docker-compose --version
  ```

### Node.jsでの使用例
#### 1 - イメージ取得
```bash
$ docker pull node:14.17.3
```

#### 2 - Docker Compose 定義
以下の内容の `docker-compose.yaml` を作成する。

```yaml
version: '3'

services:
    app:
        image: node:14.17.3
        container_name: nodejs_LTS
        tty: true
        volumes:
            - ./src:/src
        working_dir: "/src"
```

#### 3 - Node.jsの実行
##### 実行ディレクトリの構造

```
.
+ docker-compose.yaml
+ src
  + sample.js
```

##### 実行手順

```bash
# コンテナ起動
$ docker-compose up -d
# sample.js 実行
$ docker-compose run --rm app node sample.js
```

#### 参考HP
- [Docker コンテナを使って Node.js 開発を始める](https://zenn.dev/ymasaoka/articles/start-nodejs-development-with-docker)
- [Docker入門（第一回）～Dockerとは何か、何が良いのか～](https://knowledge.sakura.ad.jp/13265/)


## Porxy
Proxyを設定する必要がある場合は下記のように設定する。

### bashrc
```bash
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

### .wgetrc
wget でうまくPorxy設定がいかない場合は `.wgetrc` を作成して以下を記載する。

```bash
use_proxy=on
http_proxy=http://proxy.example.com:8080
https_proxy=http://proxy.example.com:8080
check_certificate = off
```

### apt
sudo を付けるとrootの設定を参照するため別途設定する。\
または `sudo -E` として、ユーザー設定を維持して実行でも可。

`/etc/apt/apt.conf.d/01proxy` を作成して以下を記載する。

```bash
Acquire::http::Proxy "http://proxy.example.com:8080";
Acquire::https::Proxy "http://proxy.example.com:8080";
```

### docker
`/etc/default/docker` に以下を追加する。

```bash
export no_proxy="127.0.0.1,localhost"
export NO_PROXY="127.0.0.1,localhost"
export https_proxy="http://proxy.example.co.jp:8080/"
export HTTPS_PROXY="http://proxy.example.co.jp:8080/"
export http_proxy="http://proxy.example.co.jp:8080/"
export HTTP_PROXY="http://proxy.example.co.jp:8080/"
export ftp_proxy="http://proxy.example.co.jp:8080/"
export FTP_PROXY="http://proxy.example.co.jp:8080/"
```

## ディストリビューションアップグレード
```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt --purge autoremove
$ sudo do-release-upgrade -y
```

## WSL2の再起動
PowerShellで以下のコマンドを実行する。

### ディストリビューションの確認
```PowerShell
> wsl -l -v
```

### ディストリビューションの停止
```PowerShell
> wsl -t <ディストリビューション名>
```

### ディストリビューションの実行
Windows Terminalなどでディストリビューションを選択する。


## /etc/wsl.conf と .wslconfig
### /etc/wsl.conf
```
[automount]
enabled=true                # Cドライブなどの DrvFs の自動マウントする
mountFsTab=true             # WSLの起動時に /etc/fstab を読み込んで自動的にマウントする
root="/mnt/"                # DrvFsのマウント先
options=""                  # DrvFsのマウントオプション
                            # 規定値: `uid=1000,gid=1000,umask=000,fmask=000,dmask=000`

[network]
generateHosts=true          # /etc/hosts を自動生成する
generateResolvConf=true     # /etc/resolv.conf を自動生成する

[interop]
enabled=true                # WSL内からWindowsプログラムの起動をサポートする
appendWindowsPath=true      # WSL内のPATH環境変数に、WindowsのPATH環境変数を追加する

[user]
default=<string>            # 規定のログインユーザ名を指定する
```

### .wslconfig
```
[wsl2]
kernel=<path>               # カスタム Linux カーネルへの絶対 Windows パス
kernelCommandLine=<string>  # 追加のカーネル コマンド ライン引数
memory=<size>               # WSL 2 VM に割り当てるメモリの量
processors=<number>         # WSL 2 VM に割り当てるプロセッサの数
swap=<size>                 # WSL 2 VM に追加するスワップ領域の量
                            # スワップ ファイルがない場合は 0
swapFile=<path>             # スワップ仮想ハード ディスクへの絶対 Windows パス
localhostForwarding=true    # WSLのネットワークポート待ち受けを、ホストマシンにフォワーディングする
```


## ファイルアクセス
### Windows->Linux 
`\\wsl$\Ubuntu-20.04\home\%USERNAME%`

### Linux->Windows
`/mnt/c/`


## Linuxバイナリの実行
Windows側からLinuxバイナリ（コマンド）を使用する。

```PowerShell
> wsl <コマンド>
```

### ヘルプ
```PowerShell
> wsl --help
```

## ls のカラー設定
ls標準カラー設定では Windows の表示が見づらいので以下の手順で変更する。

### ls カラー設定出力
```bash
$ dircolors -p > ~/.dircolors
```

### ls カラー設定変更
以下の値に変更する。

```
OTHER_WRITABLE 01;34 # dir that is other-writable (o+w) and not sticky
```

### ls カラー設定
.bashrc(.bash_conf)に以下の設定を追加して、.bashrc を再読み込みする。

```bash
eval $(dircolors -b ~/.dircolors)
```


# 参考HP
- [Windows 10 用 Windows Subsystem for Linux のインストール ガイド](https://docs.microsoft.com/ja-jp/windows/wsl/install-win10)
- [ディストリビューションごとの起動設定を wslconf で構成する](https://docs.microsoft.com/ja-jp/windows/wsl/wsl-config#configuration-options)