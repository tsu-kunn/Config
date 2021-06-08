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


## 参考
- [Visual Studio Code](https://code.visualstudio.com/)
- [ChromebookにLinuxを入れてまともなターミナルを得る](https://okayu-moka.hatenablog.com/entry/2020/03/14/180000)
