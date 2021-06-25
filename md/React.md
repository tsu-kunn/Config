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

※ Nodist を使用するとパッケージインストールでエラーになるものが多いため、
公式の Node.js をインストールする方法に変更。（[参考HP](https://zenn.dev/ymasaoka/articles/note-uninstall-nodish-windows)）

Node.js のバージョン管理が必要な場合は docker を使うのが今時っぽい。

#### Node.js のインストール
1. [Node.jsのサイト](https://nodejs.org/ja/) からダウンロード。
    - バージョン指定がある場合は [こちら](https://nodejs.org/ja/download/releases/) からダウンロードする。
    - バージョン指定がない場合は、特別な理由がない限り **LTSの64bit版(推奨版)** を使用する。
1. node-vxx.xx.x-x64.msi を実行して Node.js をインストール。
    - `node -v`, `npm -v`, `npx -v` でバージョンが表示されれば成功

## React App のインストール
Create React App公式サイトに記載されている方法を使用する。\
管理は開発元の Facebook が行っているみたいなので確実。

#### npx
```
$ npx create-react-app my-app
```

#### npm
```
$ npm init react-app my-app
```

#### Yarn
```
$ yarn create react-app my-app
```

### 動作確認
```
$ cd my-app
$ npm start
```

ブラウザが起動して、Reactが表示されれば正常にインストールされている。

※実行停止は Ctrl+c 

## Reat App (PWA) のインストール
`service-worker.js` が標準でインストールされなくなったので、以下のテンプレートを指定する。

```
$ npx create-react-app pwaclock --template cra-template-pwa
```

index.js の末尾の関数を `unregister` から `register` に書き換える。
```
serviceWorkerRegistration.register(); 
```


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

- homepage
  -  これを設定しておかないと build で作成した場合に正常に表示されない。

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
1. コピー先で `npm ci` を実行する。
1. 動作確認を実施する。

### 補足 
`npm install` では "package.json" を書き換えてしまう場合があるため、クリーンインストールを実行する。\
ただし。"pakage.json" と "package-lock.json" の環境が一致していないとクリーンインストールできない。

## Redux
状態の管理に Redux を使用する場合に実行する。

Redux を使う場合とつかわない場合の違い
- React単体の場合、Reactコンポーネント自身が個別に状態管理をする。
- React+Reduxの場合、状態管理する専用の場所(ストア)で状態管理し、Reactコンポーネントはそれを映すだけに徹する。

### インストール
```
$ npm install redux react-redux
```

### メモ
- Reducer でやってはいけないこと
  - 引数に手を加える
  - 副作用を起こす　例）APIコールやページ遷移
  - 純粋ではない(毎回値が変わる)関数を呼び出す　例）Data.now() や Math.random()
- Reducer の return では、全ての state の値を返す必要がある
  - 一部変更の場合
  ```JavaScript
  return {
    ...state,
    count0: state.count0 + 1,
  };
  ```


### 参考HP
- [Reac初心者でも読みば必ずわかるReactのRedux講座](https://reffect.co.jp/react/react-redux-for-beginner)
- [Todoリスト作成を通してしっかり学ぶRedux](https://reffect.co.jp/react/react-redux-todo)


## 開発メモ
### ローカルの画像表示
- public フォルダに画像ファイルを置いた場合
    - `${process.env.PUBLIC_URL}` を使用する

    ```JavaScript
    function PictureChange(props) {
        const pic1 = "/pict/amiya.png";
        const pic2 = "/pict/W_05.png";
        let picPath = props.flg ? pic1 : pic2;

        return (
            <img src={`${process.env.PUBLIC_URL}` + picPath} alt="絵" height="320" />
        );
    }
    ```

- src フォルダに画像ファイルを置いた場合
    - import を使用するのが公式のやり方

    ```JavaScript
    import pic1 from "./pict/amiya.png";
    import pic2 from "./pict/W_05.png";

    // 表示
    function PictureChange(props) {
        let picPath = props.flg ? pic1 : pic2;

        return (
            <img src={picPath} alt="絵" height="320" />
        );
    }
    ```

### Styleの動的設定
動的にCSSを設定する場合は、HTMLタグの style を使って設定する。\
優先順位は `CSSファイル > style` になるっぽい。

- 直接設定
  ```JavaScript
  let msgPadd = msg === null ? 'rgba(222, 219, 202, 0.0)' : 'rgba(222, 219, 202, 0.85)';
  let rmsgPadd = props.reactMsg === null ? 'rgba(222, 219, 202, 0.0)' : 'rgba(222, 219, 202, 0.85)';

  return (
      <React.Fragment>
          <div className="message" style={{ backgroundColor: msgPadd }}>
              <label>{msg}</label>
          </div>
          <div className="react-message" style={{ backgroundColor: rmsgPadd }}>
              <label>{props.reactMsg}</label>
          </div>
      </React.Fragment>
  );
  ```
- 変数で設定（複数を設定する場合）
  ```JavaScript
  changeApptimeStyle(bgColor) {
      let chgStyle = {
          backgroundColor: bgColor
      }

      this.setState({
          apptimeStyle: chgStyle
      })
  }

  render() {
    return (
      <div className="app-time" style={this.state.apptimeStyle} />
    );
  }
  ```


### デバッグ
#### Chrome拡張機能
[React Developer Tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) をインストールする。

##### Reactアイコンの色
- 青
  - Reactが使われているページ(リリース)で、デバッグ不可。
- 赤
  - Reactが使われているページ(デバッグ)で、デバッグ可能。

##### デバッグ方法
1. Reactアイコンが赤のページで、デベロッパーツールを表示する。
1. 上部メニューから Components を選択する。
1. デバッグしたいコンポーネントを選択し、"< >"アイコンをクリックする。
1. デバッグしたい行数をクリックし、ブレークポイントを設定する。

以後デベロッパーツールでのデバッグとなる。

#### VSCode
"task.json" と "launch.json" を作成してデバッグ設定を行う。\
詳しくは [VSCode.md](https://github.com/tsu-kunn/Config/blob/master/md/VSCode.md) の「ビルド&デバッグ設定」を参照する。

##### Electron
「Run > Add Configuration...」から `Node.js: Electron Main` を選択。


### Webフォント
Reactで使う分には <link href> で問題ない。\
Electronで使う場合は選択することになる。

- ローカルに保存（CSS の `@font-face` で `src: url('./font/FONTNAME);` を指定）
  - オフライン想定はこの方法しかない
  - リポジトリやアプリサイズが大きくなる＆ライセンス問題が発生
- レンダラープロセスのHTMLのheadに `<link href='URL'>` を記載
  - 起動時に毎回ネット接続が必要
- CSS の先頭で `@import url('URL');`
  - 1回目はネットにつながないといけないが、２回目以降はキャッシュが使われる...らしい（一番ベター）


## HP
- [React](https://ja.reactjs.org/)
  - [Create React App](https://create-react-app.dev/)
  - [Making a Progressive Web App](https://create-react-app.dev/docs/making-a-progressive-web-app/)
- [Electron](https://www.electronjs.org/)
- JavaScript
  - [JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript)
  - [JavaScript Primer](https://jsprimer.net/)
- Web Font
  - [Google Fonts](https://fonts.google.com/)
- 参考
  - [React アプリを Electron でデスクトップアプリ化する](https://absarcs.info/how-to/turning-react-apps-into-desktop-apps-with-electron/)
  - [ElectronでのWebフォントのキャッシュについて](https://qiita.com/pochman/items/22343e771528119dc7f6)
