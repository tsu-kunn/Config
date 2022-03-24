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

```JSON
"fontFace": "Myrica M",
"fontSize": 12
```

シェルごとに設定したい場合は、`"profiles": ` の `"list"` の変更したいシェル設定に追加する。

例）Git Bashのフォントを変更
```JSON
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

```JSON
"colorScheme": "テーマ名"
```

シェルごとに設定したい場合は、`"profiles": ` の `"list"` の変更したいシェル設定に追加する。

例）PowerShellのテーマを変更
```JSON
{
    "commandline": "powershell.exe",
    "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "hidden": false,
    "name": "Windows PowerShell",
    "colorScheme": "Campbell Powershell"
},
```

## Pixel Shaders
`setting.json` の default に以下の設定を追加する。

```json
"experimental.pixelShaderPath": "<path to a .hlsl pixel shader>"
```

## サンプル
- [terminal/samples/PixelShaders/](https://github.com/microsoft/terminal/tree/main/samples/PixelShaders)

## 参考HP
- [Windows Terminalの背景でレイマーチング](https://gam0022.net/blog/2021/03/08/raymarching-in-windows-terminal/)


# ショートカットキー

## 編集
|key|動作|
|:--|:--|
|Ctrl + shift + p|コマンドパレットに切り替え|
|Ctrl + ,|設定を開く(GUI)|
|Ctrl + shift + ,|設定を開く(setting.json)|
|Ctrl + c|テキストのコピー|
|Ctrl + v|貼り付け|

※注意\
コピー＆ペーストは `setting.json` で上書きされている。\
`default.json` では `Ctrl+Shift+C`, `Ctrl+Shift+V` となっており、\
Vimを使う場合は矩形選択とバッティングするので、default.jsonのショートカットキーが望ましい。

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

※`Alt + プロファイル` で新しいペインに auto 分割で追加が可能。\
　横分割、縦分割を指定して追加する方法は、ショートカット設定以外ない。(Issueにあるっぽい）\
　`toggleSplitOrientation` （ウィンドウ分割の方向切り替え）で変更可能。

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
- 外観＞アクティブなターミナルのタイトルをアプリケーションのタイトルとして使用
  - オフ
- Git Bash の追加
- 起動サイズと位置を変更
  ```JSON
  "initialCols": 140,
  "initialRows": 60,
  "initialPosition": "740, 80",
  ```
- profiles の default 変更 
  ```JSON
  "colorScheme": "One Half Dark",
  "fontFace": "Myrica M",
  "fontSize": 12
  "acrylicOpacity": 0.5,
  "useAcrylic": true
```
- profiles の Windows PowerShell のテーマを変更
  ```JSON
  "colorScheme": "Campbell Powershell"
  ```
- コピー＆ペーストのショートカットキーを変更
  ```JSON
  // Copy
  "keys": "Ctrl+Shift+C"
  // Paste
  "keys": "Ctrl+Shift+V"
  ```
- WSL2のディレクトリの開始\
  `\\wsl$\Ubuntu-20.04\home\%USERNAME%`
- キーバインドの追加・変更
  ```JSON
  "keybindings": [
      { "command": { "action": "splitPane", "split": "horizontal", "profile": "PowerShell" }, "keys": "alt+shift+P" },
      { "command": { "action": "splitPane", "split": "horizontal", "profile": "Ubuntu-20.04" }, "keys": "alt+shift+L" },
      { "command": { "action": "splitPane", "split": "horizontal", "profile": "Git Bash" }, "keys": "alt+shift+B" }
  ],
  ```

# 参考
- [Windows ターミナルの概要](https://docs.microsoft.com/ja-jp/windows/terminal/)
- [microsoft/terminal](https://github.com/microsoft/terminal)

