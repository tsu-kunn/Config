# Reactアプリの作成手順

## プロキシ
プロキシサーバーを経由している場合は以下の設定をしておく。

### npm
```
$ npm -g config set proxy http://proxy.example.com:8080
$ npm -g config set https-proxy http://proxy.example.com:8080
```

または上記をOSの環境変数に追加する。

### Electron
下記を環境変数に追加する。

```
ELECTRON_GET_USE_PROXY=true 
GLOBAL_AGENT_HTTPS_PROXY=http://proxy.example.com:8080
```

## Node.js のインストール
### Linux
```bash
$ sudo apt-get install nodejs
$ sudo apt-get install npm
```

### Windows
#### Nodist のインストール
1. [Nodistのサイト](https://github.com/nullivex/nodist/releases) からダウンロード。
    - 2021/06/03 では NodistSetup-v0.9.1.exe
1. NodistSetup-vx.x.x.exe を実行して Nodist をインストール。
    - `nodist -v` でバージョンが表示されれば成功

#### Node.jsのインストール
1. Node.js の [リリース一覧](https://nodejs.org/ja/download/releases/) からインストーするバージョンを選択する。
    - 指定がなければ LTS の一番新しいバージョンを入れるのがよい
1. `nodist + xx.xx.x` で Node.js をインストール。
    - `nodist xx.xx.x` でインストールしたバージョンに設定
1. `nodist npm match` で Node.js のバージョンに対応する npm をインストール。
    - `npm x.xx.x` でインストールしたバージョンに設定
1. `npm i npx -g` で npx をインストールする。（Nodistでは自動でインストールされない)


## React App のインストール
React公式のドキュメントで記載されている方法を使用する。\
管理は開発元の Facebook が行っているみたいなので確実。

```
$ npx create-react-app my-app
```

### 動作確認
```
$ cd my-app
$ npm start
```

ブラウザが起動して、Reactが表示されれば正常にインストールされている。

※実行停止は Ctrl+c 


## Electron のインストール
React App で作成されたディレクトリ内で下記を実行。（例では my-app ディレクトリ）

```
$ npm install --save-dev electron npm-run-all
```

### electron_main.js の作成
srcディレクトリに、以下をコピペした electron_main.js を作成する。

```JavaScript
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
    const mainWindow = new BrowserWindow({
        width: 800,
        height: 600
    });

    // load the index.html of the app.
    //mainWindow.loadFile('./build/index.html');  // 公開用
    mainWindow.loadURL("http://localhost:3000");  // 開発中

    // 開発ツールを有効
    // mainWindow.webContents.openDevTools();
}

app.whenReady().then(() ={
    createWindow();

    app.on('activate', () ={
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow();
        }
    })
});

app.on('window-all-closed', () ={
    if (process.platform !== 'darwin') {
        app.quit();
    }
});
```

### package.json の編集
package.json に以下の項目を追加する。

```json
  "name": "my-app",
  "version": "0.1.0",
  //--- 以下を追加 ---
  "homepage": "./",
  "private": true,
  "main": "src/electron_main.js",
```

```json
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    //--- 以下を追加 ---
    "appstart": "electron .",
    "dbgstart": "run-p start appstart"
  },
```

### 動作確認
```
$ cd my-app
$ npm run dbgstart
```

またはターミナルを2つ使う。

```
[ターミナル1]
$ cd my-app
$ npm start  <- Reactを起動

[ターミナル2]
$ npm run appstart  <- Electronを起動
```

Electronのアプリが起動すれば成功。

#### 実行方法
開発中は React を起動しないと Electron では表示されない。\
公開用(`npm run build` を実行した後) は Electron(`npm run appstart`) の実行のみでよい。


## 別の環境にて環境作成
1. my-app の中にある以下をコピーする。
    - public フォルダ
    - src フォルダ
    - .gitignore
    - package-lock.json
    - package.json
1. コピー先で `npm install` を実行する。
1. 動作確認を実施する。


## HP
- [React](https://ja.reactjs.org/)
  - [Create React App](https://create-react-app.dev/)
- [Electron](https://www.electronjs.org/)
- JavaScript
  - [JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript)
  - [JavaScript Primer](https://jsprimer.net/)
- 参考
  - [React アプリを Electron でデスクトップアプリ化する](https://absarcs.info/how-to/turning-react-apps-into-desktop-apps-with-electron/)
