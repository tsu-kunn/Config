# Rust のメモ

[Rust](https://www.rust-lang.org/ja/)に関するメモを集めたもの。

## インストール
### Linux/Mac/WSL2

```bash
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

#### その他
リンカやデバッガーはCのものを使うので、別途 `gcc` や `gdb` をインストールしておく必要がある。\
Cargoというパッケージ管理があるので、`make` は特に必要ない。


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
|プロジェクトの自動テスト|cargo test|
|プロジェクトのドキュメントのビルド|cargo doc|

※コンパイルするが実行ファイルは作らない

## デバッグ
### rust-gdb
`gdb` でも基本的なデバッグは可能だが、値の参照などで期待した値が得られない場合がある。\
Rust標準で提供されている `rust-gdb` を使えば、上記のような問題は発生しない。

```bash
$ rust-gdb main
```

※Windows10で試したら下記のエラーが出て、デバッグができなかった。\
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
```rust
let s: &str = "文字列";
```

C/C++の `const char *` みたいなもの。

### 文字列クラス
```rust
let msg: string = String::new();
```

C/C++の `std::string` みたいなもの。

### 文字列の結合
#### リテラル
```rust
concat!("abc", "def");
```

#### リテラル以外
```rust
format!("{}{}", "abc", "def");
```

### 文字列操作
#### 文字数
```rust
"abc".chars().count();
```

#### 文字列の結合
```rust
["Hello", "World"].connect(" ");
```

単純結合。
```rust
["Hello", "World"].concat();
```

#### 文字列の分割
```rust
"a.b.c".split(".");
"a..b..c".split_str("."):
```

### 文字列の置換
```rust
"abcdef".replace("cd", "CD");
```

### 部分文字列の検索
```rust
"abcdef".starts_with("cd");
```

### 部分文字列の取得
```rust
let s: String = String::from("🍣🍵🎮📱");
println!("{}", s.chars().nth(1).unwrap());
```

イテレーターから `nth()` でn番目の文字列を取り出す。\
Option型を返すので、`unwrap()` などを使う必要がある。

```rust
let s: String = String::from("🍣🍵🎮📱");
let begin = s.char_indices().nth(1).unwrap().0;
let end = s.char_indices().nth(3).unwrap().0;
let s = &s[begin..end];
println!("{}", s);
```

スライスを使って `🍵🎮` を取り出す。\
戻り値は `&str` なので注意。

### trim
```rust
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
- [Rustで文字列の先頭文字や部分文字列を取得する](https://qiita.com/HelloRusk/items/7fb68395984958987a54)

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

## ジェネリック型
### 関数
```rust
fn test_func<T>(x: <T>) -> T {
    ...
}
```

### 構造体
```rust
struct Point<T> {
    x: T,
    y: T,
}
```

### enum
```rust
enum hoge<T, E> {
    Hoge(T),
    Err(E),
}
```

### メソッド
```rust
impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}
```

#### 特定の型だけメソッド実装
`Point<f32>` の場合だけメソッドを実装。

```rust
impl Point<f32> {
    fn distance_from_origin(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}
```

## トレイト
### 基本
```rust
pub trait Summary {
    // 実装必須
    fn summarize_author(&self) -> String;

    // デフォルト実装
    fn summarize(&self) -> String {
        // "（もっと読む）"
        String::from("(Read more...)")
    }
}
```

#### 実装
```rust
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize_author(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }

    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}
```

### 引数としてのトレイト
```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

// 実装に書かれた実装

struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let a = NewsArticle {...};
    let b = Tweet{...};
    let c = Point{...};
    notify(&a);
    notify(&b);
    notify(&c); // Summaryトレイトを実装していないのでエラーになる
}
```

### whereを使ったトレイト境界
```rust
fn some_function<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 {
    ...
}
```

これを `where` を使って記述すると以下になる。

```rust
fn some_function<T, U>(t: &T, u: &U) -> i32
    where T: Display + Clone,
          U: Clone + Debug
{
    ...
}
```

## ライフタイム注釈記法
ライフタイムの注釈は `' + 注釈名` を記載する。\
通常すべて小文字で、ジェネリック型の様に短い `'a` を使用する。

```rust
&i32        // ただの参照
&'a i32     // 明示的なライフタイム付きの参照
&'a mut i32 // 明示的なライフタイム付きの可変参照
```

### 使用例
```rust
fun hoge<'a>(x: &'a str, y: &'a str) -> &'a str {
    ...
}
```

## テストコード
### assert!を使う
- 関数の前に `#[test]` を記載、テスト実行は `cargo test`
  ```rust
  #[test]
  fn exploration() {
      assert_eq!(2 + 2, 4);
  }
  ```
- エラー判定は `assert!(式, format形式の文字列(option))` を使う
- `assert_eq!(式, 結果)` or `assert_ne!(式, 結果)` を使うのもよい
- 自作のenumや構造体に使う場合は `#[derive(PartialEq, Debug)]` を記載しておく必要あり

### Result<T, E>を使う
`Err()` を返した場合にテスト失敗と判定することができる。

```rust
#[test]
fn result_test() -> Result<(), String> {
    if 2 + 2 == 5 {
        Ok(())
    } else {
        Err(String::from("two plus two does not equal four"))
    }
}
```

### パニックの確認
- `#[test]` の後に `#[should_panic]` を記載する
  - `#[should_panic]` は `#[should_panic(expected = "message")]` とエラーの際のメッセージを追加できる

### テスト実行の制御
#### スレッド数を指定
テストは並列実行されるが、ファイルの読み書きなど並列したくないテストの場合に設定。

```bash
$ cargo test -- --test-threads=1
```

#### 標準出力の抑制
`println' などの標準出力を抑制する。

```bash
$ cargo test -- --nocapture
```

#### 単独テスト
テストしたいテスト（関数）名を指定する。

```bash
$ cargo test exploration
```

※テスト（関数）名の一部を指定すると、その値に合致するテストが全て実行される

### 結合テスト
`tests` というディレクトリを作成し、この中に結合テストのファイルを追加する。\
このテストファイルは `cargo test` を実行した場合のみコンパイルされる。

```
クレート
+- src
+- tests
 + test_files0
 + test_files1
 +  ...
```

## クロージャ
無記名関数で、他ではlamdaとか呼ばれているもの。\
基本形は `let 関数 = |引数1, 引数2, ...| -> 戻り値 { 返却する値 };` となる。

```rust
let func = |x: i32| -> i32 {
    x * 2
};
```

クロージャは型推論を備えているので、上記は通常以下のように記載する。

```rust
let func = |x| {
    x * 2
};
```

型推論により最初に呼び出した引数の型が選ばれるため、型が違う引数はエラーになる。

```rust
let a = func(10);   // i32と推論
let b = func(1.0);  // i32と推論されているのでエラーになる
```

### 環境のキャプチャ
クロージャは自分の定義されたスコープの変数を使用することができる。\
変数の値は保存され、その後に値が変わっても影響を受けない。

```rust
fn main() {
    let mut x = 4;
    let f = |z| z == x; // x が不変で借用される
    let y = 4;
    //x = 3;            // クロージャで借用されているので変更できない
    assert!(f(y));      // 借用した x の値と比較
}
```

#### 環境のキャプチャの方法
|トレイト|動作|
|:--|:--|
|FnOnce|キャプチャした変数の所有権を奪い自身にムーブする。所有権を奪っているので1回しか呼べない。|
|FnMut|可変で値を借用する。|
|Fn|値を不変で借用する。(default)|

#### 強制的に所有権を奪う
`move` を付けることで、強制的に所有権を奪うことができる。

```rust
let f = move |z| z == x;
```

### メモ化(memoization)または、 遅延評価(lazy evaluation)
`value` が呼ばれた際にクロージャが実行される。\
値はキャッシュされるため、以後キャッシュの値を返すだけとなる。（クロージャは実行されない）

```rust
use std::thread;
use std::time::Duration;
use std::collections::HashMap;

struct Cacher<T>
    where T: Fn(u32) -> u32
{
    calculation: T,
    value: HashMap<u32, u32>,
}

impl<T> Cacher<T>
    where T: Fn(u32) -> u32
{
    fn new(calculation: T) -> Cacher<T> {
        Cacher {
            calculation,
            value: HashMap::new(),
        }
    }

    fn value(&mut self, arg: u32) -> u32 {
        match self.value.get(&arg) {
            Some(v) => *v,
            None => {
                let v = (self.calculation)(arg);
                self.value.insert(v, v);
                v
            },
        }
    }
}

fn main() {
    let mut expensive_result = Cacher::new(|num| {
        println!("calulating slowly...");
        thread::sleep(Duration::from_secs(2));
        num
    });

    println!("closure: {}", expensive_result.value(10));    // クロージャが実行されて値が設定
    println!("closure: {}", expensive_result.value(10));    // キャッシュを返す（クロージャは実行されない）
    println!("closure: {}", expensive_result.value(5));     // クロージャが実行されて値が設定
    println!("closure: {}", expensive_result.value(5));     // キャッシュを返す
    println!("closure: {}", expensive_result.value(10));    // キャッシュを返す
}
```


## コマンドラインオプション
公式トレントにある `getopts` を使用すると楽ができる。\
基本的な機能が提供されているので、難しい処理をしなければ十分使える。

### 使い方
[ドキュメント参照](https://docs.rs/getopts/0.2.21/getopts/)。

## メモ
- コメント以外で日本語があるとコンパイルに失敗する場合がある
- `_` はワイルドカードで、オブジェクトを無視するときに使用する
  ```rust
  let guess: u32 = match guess.trim().parse() {
      Ok(num) => num,
      Err(_) => return,
  };
  ```
- if文は式なので値を返すことができる
  - `let number = if flag { 5 } else { 6 };` flagに応じて5か6がnumberに設定される(三項演算子的な処理)
- `&v` は参照、 `*v` は参照外し（実データにアクセス）
- バックトレース(要Git Bash、PowerShellでは動作しない)
  - `RUST_BACKTRACE=1 cargo run`
- ? 演算子は Result を返す関数でしか使用でいない
  ```rust
  fn read_file() -> Result<String, io::Error> {
      let mut s = String::new();
      File::open("sample.txt")?.read_to_string(&mut s)?;
      Ok(s)
  }
  ```
- `トレイト` ≒ `インターフェイス` な感じ
  - ヒープ上にトレイトへのポインタを返す場合は `dyn` キーワードが必須になった
    ```
    trait Animal {}
    Box<dyn Animal>;
    ```
- コマンドライン引数
  ```rust
  use std::env;
  let args: Vec<String> = env::args().collect();
  ```
- 標準エラー出力: `eprint` や `eprintln!` を使う（e + 標準出力マクロ名）


## 参考HP
- [The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/title-page.html)
- [Rust入門](https://zenn.dev/mebiusbox/books/22d4c2ed9b0003/viewer/6d5875)


