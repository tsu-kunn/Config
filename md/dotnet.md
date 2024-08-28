# .NET Coreのメモ
[.NET SDK](https://learn.microsoft.com/ja-jp/dotnet/core/sdk) に関するメモを集めたもの。 \
主にLinuxで .NET Core を使うためも情報が中心。

## インストール
[インストールスクリプト](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script) を使ってインストールする。 \
Linux用に [Bash](https://dot.net/v1/dotnet-install.sh) と Windows用に [PowerShell](https://dot.net/v1/dotnet-install.ps1) のスクリプトがある。

### LTS
```bash
$ ./dotnet-install.sh --channel LTS
```

### パスの設定
`.bashrc` か `.profile` に以下を追加して再読み込みを行う。

```bash
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT
```

## 参考
- [.NET Core](https://dotnet.microsoft.com/ja-jp/)
- [Linuxで.NETの開発をする](https://qiita.com/unsignedint/items/94dcd1d17f829436d1b1)

