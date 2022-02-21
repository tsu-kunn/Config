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
$ apt install rust gdb
```

`gdb` は `rust-gdb` を使う際に必要になる。

### VSCode
Rust向け拡張機能。

- [Rust for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust)

### 参考
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

## デバッグ
### rust-gdb
`gdb` でも基本的なデバッグは可能だが、値の参照などで期待した値が得られない場合がある。\
Rust標準で提供されている `rust-gdb` を使えば、上記のような問題は発生しない。

```bash
$ rust-gdb main
```

※Windows10で試したら下記のエラーが出て、デバッグが気なかった。\
　軽く調べた感じ解決策がなさそうなので、WindowsではVSCodeを使ったデバッグが望ましい。（MSもそういってる）

`error: the 'rust-gdb.exe' binary, normally provided by the 'rustc' component, is not applicable to the 'stable-x86_64-pc-windows-msvc' toolchain`

### VSCode
以下の手順でデバッグ設定ファイルを作成する。

1. [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb) 拡張機能をインストール。
1. VSCodeの左サイドメニューからデバッグ実行を選択し、`launch.jsonファイルを作成します。` をクリックする。
1. コマンドパレットが開くので、`LLDB` を選択する。
1. ダイアログが表示されるので `Yes` を選択する。（Cargo.tomlに基づいて作成）
1. ブレークポイント設定後、`F5` でデバッガー実行開始。

※CodeLLDBをインストールして `F5` でも `launch.json` が作成されデバッグできた。

主に以下の機能が提供される。（まだまだあるかも）
- ブレークポイント
- 逐次実行
- ウォッチ式定義
- コールスタック

## ドキュメント参照
### ローカル
使用しているトレイとクレートなどのメソッドや関数を調べることができます。

```bash
$ cargo doc --open
```

### ネット
- [Docs.rs](https://docs.rs/)

## 命名規則
| Item | Convention |
| ---- | ---------- |
| Crates | `snake_case` (but prefer single word) |
| Modules | `snake_case` |
| Types | `UpperCamelCase` |
| Traits | `UpperCamelCase` |
| Enum variants | `UpperCamelCase` |
| Functions | `snake_case` |
| Methods | `snake_case` |
| General constructors | `new` or `with_more_details` |
| Conversion constructors | `from_some_other_type` |
| Local variables | `snake_case` |
| Static variables | `SCREAMING_SNAKE_CASE` |
| Constant variables | `SCREAMING_SNAKE_CASE` |
| Type parameters | concise `UpperCamelCase`, usually single uppercase letter: `T` |
| Lifetimes | short, lowercase: `'a` |

### 参考
- [rfcs/text/0430-finalizing-naming-conventions.md](https://github.com/rust-lang/rfcs/blob/master/text/0430-finalizing-naming-conventions.md)

## 基本データ型
|型|種類|
|:--|:--|
|整数|i8, u8, i16, u16, i32, u32, i64, u64, isize, usize|
|浮動小数点|f32, f64|
|ブーリアン|bool|
|文字|char|
|タプル|(256, abc, true)|
|配列|[1, 2, 3, 4]|

### Copyトレイト
整数、浮動小数点、ブーリアン、文字の型の場合、Copyトレイトが実行され、所有権が維持される。\
タプルの場合は、上記の型の場合はCopyトレイトが実行されるが、Stringなど他の型が含まれていると実行されないので注意が必要。

タプル例）
```rust
// Copyトレイト可能
let a: (i32, f32) = (256, 123.456);

// Copyトレイト不可
let b: (i32, String) = (64, "hoge");
```

## 文字列
### 文字列リテラル
```
let s: &str = "文字列";
```

C/C++の `const char *` みたいなもの。

### 文字列クラス
```
let msg: string = String::new();
```

C/C++の `std::string` みたいなもの。

### 文字列の結合
#### リテラル
```
concat!("abc", "def");
```

#### リテラル以外
```
format!("{}{}", "abc", "def");
```

### 文字列操作
#### 文字数
```
"abc".chars().count();
```

#### 文字列の結合
```
["Hello", "World"].connect(" ");
```

単純結合。
```
["Hello", "World"].concat();
```

#### 文字列の分割
```
"a.b.c".split(".");
"a..b..c".split_str("."):
```

### 文字列の置換
```
"abcdef".replace("cd", "CD");
```

### 部分文字列の検索
```
"abcdef".starts_with("cd");
```

### 部分文字列の取得
```
"abcdef".slice_chars(1, 2);
```

### trim
```
"xaxxbxxcxd".trim_matches("x");
```

### スライス
`[開始位置..終了位置]` でStringの一部を取得する。

```rust
let s = String::from("Hello world");
let h = &s[0..5];
let w = &s[6..11];
```

- `[..5]` で開始位置(0)省略
- `[6..]` で終了位置(s.len())省略
- `[..]` で文字列全体

### 参考
- [Rustの文字列操作](https://qiita.com/aflc/items/f2be832f9612064b12c6)

## ファイル分割
ファイル構成。

```
.
├── Cargo.lock
├── Cargo.toml
└── src
     ├── guessing.rs
     ├── lib.rs
     └── main.rs
```

`main.rs` から `guessing.rs` に分割する場合。\
`lib.rs` を作成し、ここに公開する情報をまとめていく。

### lib.rs
`lib.rs` を作成し、以下を記載する。

``` rust
pub mod guessing;
```

`pub mod` に指定する `guessing` はファイル名。（guessingの中の mod ではないので注意）\
モジュール名の最初は必ずファイル名になるっぽい。（`ファイル名::最初のmod名::次のmod名` になる）

### main.rs
行頭に `extern crate クレート名;` を記載する。（これなくても動作するっぽい、要調査）\
クレート名はモジュール化する場合はスネークケース(snake_case)にしないと警告が出るので注意。\
`Cargo.toml` の `[package]` の `name` に書かれている名前と一致している必要がある。\
（`cargo new project_name` で作成している場合は気にする必要なし）

※クレート名が `rust_test` の場合。
``` rust
extern crate rust_test;
```

公開したモジュールを使いたいので `use` を使ってスコープに持ち込む。

``` rust
use rust_test::guessing;
```

## 所有権
Rustはメモリ管理機能がない代わりに所有権というものがある。\
関数の引数にしたりすると所有権が移り、元の変数が使えなくなる。\
（特定の型だとCopyトレイトが実行されるので、所有権が移らない場合がある）

その為、呼び出し元でも継続利用する場合は参照渡しを使用する。\
ただし、特定のスコープで、ある特定のデータに対しては、 一つしか可変な参照を持てない。

### 例）
```Rust
fn main() {
    another_function(x, y); // 関数の x に移るが、i32なのでCopyとなる
    println!("x = {}", x);  // Copyなので、ここでも使える

    let s = String::from("String Test 1");
    print_function1(s);      // ここで所有権が関数の s に移る
    // println!("Test1: {}", s);   // 所有権が移っているので使用できない

    let s = String::from("String Test 2");
    print_function2(&s);        // 参照になったので所有権が残る
    println!("Test2: {}", s);   // 所有権が残っているので、ここでも使用でいる

    let mut s = String::from("String Test 3");
    print_function3(&mut s);    // 変更可能な参照
    println!("Test3: {}", s);   // 変更可能な参照なので、文字列が変わっている
}

fn another_function(x: i32, y: i32) {
    println!("The value of x is: {}", x);
    println!("The value of y is: {}", y);
}

fn print_function1(s: String) {
    println!("{}", s);
}

fn print_function2(s: &String) {
    println!("{}", s);
}

fn print_function3(s: &mut String) {
    println!("{}", s);
    s.push_str(", custom!!");
}
```

## 関数ポインタ的なもの
```rust
fn add(x: i32, y: i32) -> i32 {
    x + y
}

fn main() {
    let x: fn(i32,i32) -> i32 = add;
}
```

## メモ
- コメント以外で日本語があるとコンパイルに失敗する場合がある
- `_` はワイルドカードで、オブジェクトを無視するときに使用する
- if文は式なので値を返すことができる
  - `let number = if flag { 5 } else { 6 };` flagに応じて5か6がnumberに設定される(三項演算子的な処理)


## 参考HP
- [The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/title-page.html)
- [Rust入門](https://zenn.dev/mebiusbox/books/22d4c2ed9b0003/viewer/6d5875)


