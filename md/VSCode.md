# VisualStudio Code(VSCode)の個人メモ

## 設定ファイルの配置場所
- setting.json
  - 設定ファイル
- keybindings.json
  - ショートカットキーの設定ファイル

### Windows
```
C:\Users\[ユーザー名]\AppData\Roaming\Code\User
```

または

```
%APPDATA%\Code\User
```

### Linux
```
$ ~/.config/Code/user/
```

### macOS
```
~/Library/Application Support/Code/User
```

#### 設定ファイルバックアップ
- https://github.com/tsu-kunn/Config/tree/master/Code/User


## 設定ファイルの同期
VSCodeの標準機能を使用する。MSアカウントかGitHubアカウントが必要。

- [Visual Studio Code公式の設定同期「Settings Sync」を利用する](https://qiita.com/Nuits/items/6204a6b0576b7a4e37ea)
  - 基本的な使い方が網羅されている
- [VSCode公式の機能で設定を同期する【Insiders Preview】](https://qiita.com/suzuki_sh/items/c52414b5bd03d52d4de5#:~:text=%E8%A8%AD%E5%AE%9A%E5%90%8C%E6%9C%9F%E6%96%B9%E6%B3%95,Sync%20%E3%82%92%E5%85%A5%E5%8A%9B%E3%81%97%E3%81%BE%E3%81%99%E3%80%82)
  - ChromeOSのLinuxでの注意点の記載あり


## インストールした拡張
- AsciiDoc
  - ASCII Doc の編集用
- Bash Beautify
  - Bashのシェルスクリプトのシンタックスハイライト
- C/C++
  - C/C++のビルド～デバッグまでを実施
- Center Editor Window
  - `Ctrl + l` でカーソル位置を中央表示する
- Gauge
  - [Gauge](https://gauge.org/) のプロジェクト作成などを実施
- glsl-canvas
  - GLSLのプレビューを行う
- Path Autocomplete
  - パスを入力する際に補完を行う
- PowerShell
  - PowerShellスクリプトの統合開発環境（Windows PowerShell & PowerShell 6～）
- Python
  - Pythonの統合開発環境（別途Pythonのインストールが必要）
- Shader languages support for VS Code
  - HLSL/GLSL/Cgのシンタックスハイライト
- vscode-icons
  - エクスプローラーのファイルにアイコンを表示
- zenkaku
  - 全角スペースをハイライトする

### 気になってる拡張
- Git History
  - VSCode上でGitの履歴を見えるようにする
- GitLens
  - Gitクライアント的な操作を可能にする

※Git + Tig で問題ないので保留中


## ChromeOS の Linux にインストール
### 1. フォントの追加
```bash
$ sudo apt update
$ sudo apt upgrade -y
$ sudo apt install -y task-japanese locales-all fonts-noto-cjk
$ sudo localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
$ source /etc/default/locale
```

### 2. fcitx-mozcのインストールと設定
```bash
$ sudo apt install -y fcitx-mozc fcitx-frontend-all
$ fcitx-autostart
$ fcitx-configtool
```

表示されたダイアログ左下の "+" ボタンから "mozc" を追加する。

#### Linux のGUIで日本語入力可能にする
`/etc/systemd/user/cros-garcon.service.d/cros-garcon-override.conf` に以下を追加。

```bash
$ sudo sh -c 'echo Environment=\"GTK_IM_MODULE=fcitx\" >> /etc/systemd/user/cros-garcon.service.d/cros-garcon-override.conf'
$ sudo sh -c 'echo Environment=\"QT_IM_MODULE=fcitx\"  >> /etc/systemd/user/cros-garcon.service.d/cros-garcon-override.conf'
$ sudo sh -c 'echo Environment=\"XMODIFIERS=fcitx\"    >> /etc/systemd/user/cros-garcon.service.d/cros-garcon-override.conf'
```

### 3. fctixを自動起動させる
```bash
$ echo '/usr/bin/fcitx-autostart' > ~/.sommelierrc
```

### 4. フォントの追加
Myrica M を使いたいので下記の方法でインストールする。

```bash
$ mkdir ~/tmp
$ cd ~/tmp
$ wget https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip
$ unzip Myrica.zip
$ sudo mv Myrica.TTC /usr/share/fonts/
$ fc-cache -f -v
$ cd ~/
$ rm -rf ~/tmp
```

## ビルド&デバッグ設定
### C/C++
#### c_cpp_properties.json の作成
"Ctrl + Shift + P" から "C/C++: Edit Configurations (UI)" を選択する。\
これらの設定はビルドやインテリセンスの候補に使用される。

- 使用するコンパイラの設定
  - コンパイラのパス
  - コンパイラへの引数
  - IntelliSense モード
- プロジェクトに追加する include ディレクトリの追加
- プロジェクトで使用するビルド用定義(define)の追加
- CとC++の標準規格の指定

#### tasks.json の作成
「Terminal > Configure Tasks...」から `C/C++: gcc アクティブなファイルのビルド` を選択し、下記の内容に書き換える。\
現在表示しているソースファイルをビルドする設定。

```json
{
    "type": "cppbuild",
    "label": "C/C++: gcc アクティブなファイルのビルド",
    "command": "/usr/bin/gcc",
    "args": [
        "-std=c11",
        "-Wall",
        "-fexceptions",
        "-Wuninitialized",
        "-g",
        "-I./include",
        "${file}",
        "-o",
        "${fileDirname}/${fileBasenameNoExtension}"
    ],
    "options": {
        "cwd": "${workspaceFolder}"
    },
    "problemMatcher": [
        "$gcc"
    ],
    "group": {
        "kind": "build",
        "isDefault": true
    },
    "detail": "デバッガーによって生成されたタスク。"
},
```

- label
  - タスク名。"launch.json" で指定する場合に使われるので、わかりやすい名前にする。
- args
  - コンパイルの際に使用する引数やパラメーターを指定する。
- detail
  - 詳細説明。任意に編集する。


##### makefile を使用してビルド
"tasks.json" に下記のmakeビルドの設定を追加する。

```json
{
    "label": "Makefile",
    "type": "shell",
    "command":"make",
    "args": [],
    "group": "build"
}
```

- label
  - タスク名。"launch.json" で指定する場合に使われるので、わかりやすい名前にする。
- type
  - シェルを指定する。（シェルから make を実施するため）
- command
  - シェルで実行するコマンド。
- args
  - make に渡すパラメーターがある場合記載。（例: NDEBUG=TRUE など）
- group 
  - build グループに設定する。


#### launch.json の作成
「Run > Add Configuration...」から `C/C++: (gdb) 起動` を選択し、以下の内容に書き換える。

```json
{
    "name": "gcc - アクティブ ファイルのビルドとデバッグ",
    "type": "cppdbg",
    "request": "launch",
    "program": "${fileDirname}/${fileBasenameNoExtension}",
    "args": [],
    "stopAtEntry": false,
    "cwd": "${workspaceFolder}",
    "environment": [],
    "externalConsole": false,
    "MIMode": "gdb",
    "setupCommands": [
        {
            "description": "gdb の再フォーマットを有効にする",
            "text": "-enable-pretty-printing",
            "ignoreFailures": true
        }
    ],
    "preLaunchTask": "C/C++: gcc アクティブなファイルのビルド",
    "miDebuggerPath": "/usr/bin/gdb"
},
```

- name
  - "Run and Debug" に表示される名前。分かりやすい名前に変更する。
- args
  - 実行ファイルに渡すパラメーターがあれば設定する。
- preLaunchTask
  - デバッグをする前に実行するタスクを設定する。
    - ここでは前に作成したタスクの label値 を指定。

##### makefile を使用してのデバッグ
"launch.json" に下記のmakeビルドの設定を追加する。

```json
{
    "name": "blankcut make buid",
    "type": "cppdbg",
    "request": "launch",
    "program": "${workspaceRoot}/blankcut",
    "args": [
        "-w",
        "128",
        "-h",
        "128",
        "-g",
        "-t",
        "./pict/sample_256.bmp",
        "./output/sample_256.blc"
    ],
    "stopAtEntry": false,
    "cwd": "${workspaceFolder}",
    "environment": [],
    "externalConsole": false,
    "MIMode": "gdb",
    "setupCommands": [
        {
            "description": "gdb の再フォーマットを有効にする",
            "text": "-enable-pretty-printing",
            "ignoreFailures": true
        }
    ],
    "preLaunchTask": "Makefile",
    "miDebuggerPath": "/usr/bin/gdb"
}
```

- name
  - "Run and Debug" に表示される名前。分かりやすい名前に変更する。
- args
  - 実行ファイルに渡すパラメーターがあれば設定する。
- preLaunchTask
  - make実行のタスクを指定する。
    - ここでは前に作成したタスクの label値 を指定。

#### デバッグ開始
デバッグタブ（Run and Debug）の上部（▶）のリストから、"launch.json" に追加した名前を選択する。\
▶アイコンかF5キーを押下すればデバッグが開始される。

#### デバッグの終了
以下のいずれかを実行する。

- デバッグコントロールの□ボタンを押下
- "Shift-F5" キーを押下

### React
#### task.json の作成
「Terminal > Configure Tasks...」から `npm: start` を選択し、下記の内容に書き換える。

```json
{
  "type": "npm",
  "script": "start",
  "path": "react/my-app/",
  "label": "npm: start",
  "detail": "react-scripts start",
  "isBackground": true,
  "group": {
    "kind": "test",
    "isDefault": true
  },
  "problemMatcher": {
    "owner": "custom",
    "pattern": {
      "regexp": "ˆ$"
    },
    "background": {
      "activeOnStart": true,
      "beginsPattern": "Compiling...",
      "endsPattern": "Compiled .*"
    }
  }
}
```

- path
  - npm を実行する場所。workspaceFolder 直下ではない場合追加される。
- label
  - タスク名。"launch.json" で指定する場合に使われるので、わかりやすい名前にする。
- detail
  - 詳細説明。任意に変更する。
- problemMatcher
  - エラー発生時にVSCodeに渡されるメッセージフォーマットを指定する。
    - 既存のものを指定する場合は `"problemMatcher": [$tsc]` のような形式になる。
  - 任意のメッセージを指定する場合は上記のような記載となる。
    - Reactが実行完了になるまで待つように指定

##### 補足
`npm start` で自動的にブラウザが起動するが、デバッグで使うブラウザではないので、
非表示にしたい場合は、以下の内容の ".env" ファイルを npm 実行フォルダに作成する。

```
BROWSER=none
```

#### launch.json の作成
「Run > Add Configuration...」から `{} Chrome: Launch` を選択し、以下の内容に書き換える。

```json
{
    "name": "React Debug",
    "request": "launch",
    "type": "pwa-chrome",
    "preLaunchTask": "npm: start",
    "url": "http://localhost:3000",
    "webRoot": "${workspaceFolder}/react/my-app",
    "sourceMaps": true,
    "sourceMapPathOverrides": {
        "webpack:///./~/*": "${webRoot}/node_modules/*",
        "webpack://?:*/*": "${webRoot}/*",
        "webpack:///./*": "${webRoot}/src/*"
    }
},
```

- name
  - "Run and Debug" に表示される名前。分かりやすい名前に変更する。
- preLaunchTask
  - デバッグをする前に実行するタスクを設定する。
    - ここでは前に作成したタスクの label値 を指定。
- webRoot
  - URLのルートとなるフォルダパスを設定する。
    - workspaceFolder 直下ではない場合はパスを追加する。
- sourceMapPathOverrides
  - `${workspaceFolder}` を `${webRoot}` に置き換える。

#### デバッグ開始
デバッグタブ（Run and Debug）の上部（▶）のリストから、"launch.json" に追加した名前を選択する。\
▶アイコンかF5キーを押下すればデバッグが開始される。

#### デバッグの終了
以下のいずれかを実行する。

- ブラウザを閉じる
- デバッグコントロールの□ボタンを押下
- "Shift-F5" キーを押下

引き続きデバッグを行う場合は、タスクは実行したままにする。（デバッグ開始の時間が短縮できる）

#### タスクの終了
以下のいずれかを実行する。

- ターミナルウィンドウで "Ctr + c" を押下
- ターミナルウィンドウのごみ箱アイコンを押下

## メモ
### ショートカットキー備忘録
|key|動作|
|:--|:--|
|Ctrl + Alt + shift + カーソルキー|矩形選択|
|Ctrl + Shift + L|現在のカーソル位置にある同じ単語を一括選択|
|Ctrl + Alt + ↑/↓|複数行編集|
|Ctrl + Alt + b|サイドバー非表示・表示 ※ショートカットキー変更|
|Alt + ↑/↓|カーソル行を移動（複数行対応）|
|Alt + shift+ ↑/↓|カーソル行をコピー（複数行対応）|
|Ctrl + K, Ctrl + ]|カーソルのあるインデントを子インデント含め展開する|


## 参考
- [Visual Studio Code](https://code.visualstudio.com/)
- [ChromebookにLinuxを入れてまともなターミナルを得る](https://okayu-moka.hatenablog.com/entry/2020/03/14/180000)
