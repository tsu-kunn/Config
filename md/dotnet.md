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
### 入力補完
以下を `.bashrc` などに記載する。

```bash
# bash parameter completion for the dotnet CLI
function _dotnet_bash_complete()
{
    local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n' # On Windows you may need to use use IFS=$'\r\n'
    local candidates

    read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)
    read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
}
```

## コンソールプロジェクト
### 作成
```bash
$ dotnet new console -o sample
```

### ビルド
```bash
$ dotnet build
```

プロジェクトディレクトリ内の `*.cs` が自動検知してビルド対象になる。 \
VisualStdioみたいに `sample.csproj` を編集したらエラーになった。

### 実行
```bash
$ dotnet run
```

## dotnet コマンド
- [.NET CLI の概要](https://learn.microsoft.com/ja-jp/dotnet/core/tools/#cli-commands)
- [dotnet コマンド](https://learn.microsoft.com/ja-jp/dotnet/core/tools/dotnet)

## 参考
- [.NET Core](https://dotnet.microsoft.com/ja-jp/)
- [Linuxで.NETの開発をする](https://qiita.com/unsignedint/items/94dcd1d17f829436d1b1)

