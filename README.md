# Config
環境設定ファイルやmdメモを保存するリポジトリ。\
VSCode(Windows/Linux) + Bash環境の設定ファイルが中心。

## 構成
- BashConfig
  - BashやVim、Gitなどの設定ファイル置き場。
  - WindowsのGit Bash、ChromebookのLinux環境、AndroidのTermuxで動作することを確認済み
    - ~~使用しているコマンドがないため、一部の関数がTermuxで動作しない~~
    - [Termux用のnkfを作成](https://github.com/tsu-kunn/nkf/releases/tag/v2_1_5_Termux) したので全て動作する。
- C
  - C言語のベース環境（C11対応）
- Cpp
  - C++のベース環境（C++17対応） ※やっぱりC/C++が一番好き!!
- Code
  - VisualStudio Code(VSCode)の設定ファイル。
  - Settings Syncでうまく同期できなかった時用のバックアップ。
- md
  - Markdown形式で書かれたメモファイル置き場。
- Office
  - Excel/Word/Outlook/VisioのカスタムUIのエクスポートファイル。
- PowerShell
  - PowerShellの設定ファイル。
    - Windows PowerShellとPowerShellのprofileを分離。
  - 一部の関数はWindows依存になっている。
- WindowsTerminal
  - Windows Terminalの設定ファイル。
- WSL2
  - Windows側に置くWSL2の設定ファイル。
- xyzzy
  - VSCodeが1.5になるまで20年以上愛用したエディターの個人設定ファイル。 

## その他
- [Windows用コマンドツール](https://drive.google.com/file/d/1hOZdNA-IgRVNrovc1QxtD4_bAVy8V_yj/view?usp=sharing)
  - 7za, jq, nkf, makeなど

## ライセンス（License）
自己責任でご自由にお使いください。
（Feel free to use it at your own risk.）
