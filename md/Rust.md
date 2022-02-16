# Rust のメモ

[Rust](https://www.rust-lang.org/ja/)に関するメモを集めたもの。

## インストール
### Linux/Mac/WSL2

```bash
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

### Windows
[Rustのインストーラー](https://www.rust-lang.org/ja/tools/install) をダウンロードして実行する。


#### Visual Studio 2013以降用のC++ビルドツールも必要になるという旨のメッセージが出た場合
1. `N` を入力してRustのインストーラーを終了する。
1. [Microsoft C++ Build Tools](https://visualstudio.microsoft.com/ja/visual-cpp-build-tools/)をダウンロードして実行する。
1. ワークロード選択で「C++によるデスクトップ開発」を選択する。（Windows10 SDKが選択されていることを確認）
1. 言語パックで「英語」を選択する。（日本語が必要な場合は日本語と英語を選択）
1. インストールボタンを押下してインストールを実行する。（要再起動）
1. Rustのインストーラーを再度実行する。

### 共通
1. 選択肢が表示されたら `1` を入力
1. `Rust is installed` が表示されたれらインストール成功。
1. ターミナルを開いている場合は再起動させる。（パスが追加されているため）

バージョン確認は以下のコマンドを実行する。

```bash
$ rustc --version
rustc 1.58.1 (db9d1b20b 2022-01-20)
```


### Termux
```bash
$ apt install rust
```

## 参考
- [はじめに](https://www.rust-lang.org/ja/learn/get-started)


## 更新
最新版への更新は以下のスクリプトを実行する。

```bash
$ rustup update
```

## 基本操作
### コンパイラ
```bash
$ rustc main.rc
```

### パッケージ
|動作|コマンド|
|:--|:--|
|プロジェクトの作成|cargo new [project name]|
|プロジェクトのビルド|cargo build|
|プロジェクトのリリースビルド|cargo build --release|
|プロジェクトの確認※|cargo check|
|プロジェクトの実行|cargo run|
|プロジェクトのテスト|cargo test|
|プロジェクトのドキュメントのビルド|cargo doc|

※コンパイルするが実行ファイルは作らない

## 参考HP
- [The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/title-page.html)
- [Rust入門](https://zenn.dev/mebiusbox/books/22d4c2ed9b0003/viewer/6d5875)


