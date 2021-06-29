# Windows Terminal

## インストール
- Microsoft Store (基本はこちら)
  - "Windows Terminal" と検索してインストール
- GitHub (上記が使えない場合)
 1. [Release/microsoft/terminal](https://github.com/microsoft/terminal/releases)
 1. ダウンロードするバージョンの `Assets` をクリック
 1. `Microsoft.WindowsTerminal_バージョン_8wekyb3d8bbwe.msixbundle` をクリックしてダウンロード
 1. `Microsoft.WindowsTerminal_バージョン_8wekyb3d8bbwe.msixbundle` を実行する

## Git Bash 追加
1. 設定を表示する
1. 「プロファイル」の新規追加を押下する
1. 以下の設定を行う
    - 名前
      - Git Bash
    - コマンドライン
      - C:\Program Files\Git\bin\bash.exe
    - アイコン
      - C:\Program Files\Git\mingw64\share\git\git-for-windows.ico
1. 保存ボタンと押下する

## フォントの変更
`setting.json` を開いて `"profiles": ` の `"defaults"` に以下を追加する。

```
"fontFace": "Myrica M",
"fontSize": 12
```

シェルごとに設定したい場合は、`"profiles": ` の `"list"` の変更したいシェル設定に追加する。

例）Git Bashのフォントを変更
```
{
    "commandline": "C:\\Program Files\\Git\\bin\\bash.exe",
    "icon": "C:\\Program Files\\Git\\mingw64\\share\\git\\git-for-windows.ico",
    "name": "Git Bash",
    "startingDirectory": "%USERPROFILE%",
    "fontFace": "Myrica M",
    "fontSize": 12
}
```

## 配色の変更
### 選べるテーマ
- Campbell
- Campbell Powershell
- Vintage
- One Half Dark
- One Half Light
- Solarized Dark
- Solarized Light
- Tango Dark
- Tango Light

### 設定
`setting.json` を開いて `"profiles": ` の `"defaults"` に以下を追加する。

```
"colorScheme": "テーマ名"
```

シェルごとに設定したい場合は、`"profiles": ` の `"list"` の変更したいシェル設定に追加する。

例）PowerShellのテーマを変更
```
{
    "commandline": "powershell.exe",
    "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "hidden": false,
    "name": "Windows PowerShell",
    "colorScheme": "Campbell Powershell"
},
```

# ショートカットキー

## 編集
|key|動作|
|:--|:--|
|Ctrl + shift + p|コマンドパレットに切り替え|
|Ctrl + ,|設定を開く(GUI)|
|Ctrl + shift + ,|設定を開く(setting.json)|
|Ctrl + c|テキストのコピー|
|Ctrl + v|貼り付け|

## ウィンドウ
|key|動作|
|:--|:--|
|Alt + shift + d|ウィンドウの複製|
|Alt + shift + -|ウィンドウを横に分割|
|Alt + shift + +|ウィンドウを縦に分割|
|Ctrl + shift + w|ウィンドウを閉じる|
|Alt + shift + ↑|ウィンドウのサイズを変更・上|
|Alt + shift + ↓|ウィンドウのサイズを変更・下|
|Alt + shift + →|ウィンドウのサイズを変更・右|
|Alt + shift + ←|ウィンドウのサイズを変更・左|
|Ctrl + shift + pgup|1ページ上にスクロール|
|Ctrl + shift + pgdn|1ページ下にスクロール|
|Alt + ↑|フォーカスを移動・上|
|Alt + ↓|フォーカスを移動・下|
|Alt + →|フォーカスを移動・右|
|Alt + ←|フォーカスを移動・左|
|F11|全画面表示|

## タブ
|key|動作|
|:--|:--|
|Ctrl + shift + t|新しいタブ|
|Ctrl + shift + space|新しいタブ・ドロップダウンを開く|
|Ctrl + shift + 1-9|新しいタブ・profile 1-9|
|Ctrl + shift + d|タブの複製|
|Ctrl + Alt + 1-9|タブの切り替え|
|Ctrl + tab|次のタブ|
|Ctrl + shift + tab|前のタブ|

## フォント
|key|動作|
|:--|:--|
|Ctrl + 0|フォントサイズをリセット|
|Ctrl + numpad_+|フォント拡大|
|Ctrl + numpad_-|フォント縮小|


# 変更点
- スタートアップ＞起動サイズの変更
  - 列: 140
  - 行: 60
- 外観＞アクティブなターミナルのタイトルをアプリケーションのタイトルとして使用
  - オフ
- Git Bash の追加
  - 既定プロファイルに設定
- profiles の default 変更 
  ```
  "colorScheme": "One Half Dark",
  "fontFace": "Myrica M",
  "fontSize": 12
  ```
- profiles の PowerShell のテーマを変更
  ```
  "colorScheme": "Campbell Powershell"
  ```

# 参考
- [Windows ターミナルの概要](https://docs.microsoft.com/ja-jp/windows/terminal/)

