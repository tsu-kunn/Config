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

## ドキュメント作成
### 通常
関数やメソッドの上部に `///` を使用することでドキュメンテーションコメントを使用することができる。\
Markdown記法をサポート。

`# Examples` 以外にも `Panics` や `Errors` がよく使用されている。
- Examples
  - 関数やメソッドの使い方
  - `cargo test` を実行した際にコード例がテストとして実行される
- Panics
  - `panic!` する可能性のある筋書
- Erros
  - `Result` を返す場合の起こりうるエラーの種類や条件

```rust
/// Adds one to the number given.
///
/// # Examples
///
/// ```
/// let five = 5;
///
/// assert_eq!(6, my_crate::add_one(5));
/// ```
pub fn add_one(x: i32) -> i32 {
    x + 1
}
```

### 要素にコメント
`//!` を使用することでドキュメンテーションを付け加えることができる。\
主にクレートのルートファイル内部や、モジュール内部に使用する。

```rust
//! # My Crate
//!
//! `my_crate` is a collection of utilities to make performing certain
//! calculations more convenient.
```

### 確認
```bash
$ cargo doc --open
```

### 参考
- [Crates.ioにクレートを公開する](https://doc.rust-jp.rs/book-ja/ch14-02-publishing-to-crates-io.html)

## 基本データ型
|型|種類|
|:--|:--|
|整数|i8, u8, i16, u16, i32, u32, i64, u64, isize, usize|
|浮動小数点|f32, f64|
|ブーリアン|bool|
|文字|char|
|タプル|(256, abc, true)|
|配列|[1, 2, 3, 4]|

### キャスト
`as` 演算子を使うことで、明示的なキャストが行える。\
数字、bool、charなど一部の型のみで利用ができる。

整数のサイズが小さくなる場合は上位ビットが切り詰められる。

```rust
let x: u8 = 150;
let y = x as i8;

let x: i32 = 1023;
let y = x as u8;
```

#### キャストに関するトレイト
数が多いので [ここ](https://zenn.dev/take4s5i/articles/rust-type-convertion) を参照。

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

### フォーマット
`{}` が基本の型で `{n}` で引数に置き換えられる。

#### 揃え
|型|揃え|
|:--|:--|
|{x: <n}|n桁左寄せ|
|{x: >n}|n桁右寄せ|
|{x: ^n}|n桁中央寄せ|
|{x: >0n}|0埋め|

### 基数
|型|基数|
|:--|:--|
|{:b}|バイナリ|
|{:o}|8進数|
|{:x}|16進数|
|{:e}|指数表示|

### 参考
- [Rustの文字列操作](https://qiita.com/aflc/items/f2be832f9612064b12c6)
- [Rustで文字列の先頭文字や部分文字列を取得する](https://qiita.com/HelloRusk/items/7fb68395984958987a54)

## if let
`if let記法` で `if` と `let` をより冗長性の少ない方法で組み合わせ、残りを無視しつつ、一つのパターンにマッチする値を扱うことができる。

`match` で記述した場合。

```rust
let some_u8_value = Some(0u8);
match some_u8_value {
    Some(3) => println!("three"),
    _ => (),
}
```

これを `if let記法` で書いた場合。`else`も使うことができる。

```rust
if let Some(3) = some_u8_value {
    println!("three");
}
```

## while let
`if let` と構成が似て、パターンが合致し続ける限りループが実行される。

```rust
let mut stack = Vec::new();

stack.push(1);
stack.push(2);
stack.push(3);

// 4回目に None が返り、ループを抜ける
while let Some(top) = stack.pop() {
    println!("{}", top);
}
```

## パターン記法
### リテラル
switch文的な動作。

```rust
let x = 1;

match x {
    1 => println!("one"),       // 1
    2 => println!("two"),       // 2
    3 => println!("three"),     // 3
    _ => println!("anything"),  // なんでも
}
```

### 名前付き変数
```rust
let x = Some(5);

match x {
    Some(50) => println!("Got 50"),
    Some(x) => println!("Matched, x = {:?}", x),
    _ => println!("Default case, x = {:?}", x),     // 上記以外
}
```

### 複数パターン
`|` で or を取ることが可能。

```rust
let x = 2;

match x {
    1 | 2 => println!("one or two"),    // 1か2
    3 => println!("three"),
    _ => println!("anything"),
}
```

`...` で範囲指定も可能。

```rust
let x = 5;

match x {
    // 1から5まで
    1 ... 5 => println!("one through five"),
    // それ以外
    _ => println!("something else"),
}
```

`char` 型の場合。

```rust
let x = 'c';

match x {
    'a' ... 'j' => println!("early ASCII letter"),
    'k' ... 'z' => println!("late ASCII letter"),
    _ => println!("something else"),
}
```

### 構造体
#### フィールド名と別名に保存
構造体の `x`, `y` の値を、変数 `a`, `b` に保存。

``` rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 0, y: 7 };

    let Point { x: a, y: b } = p;
    assert_eq!(0, a);
    assert_eq!(7, b);
}
```

#### フィールド名と同名に保存
```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 0, y: 7 };

    let Point { x, y } = p;
    assert_eq!(0, x);
    assert_eq!(7, y);
}
```

#### matchで比較
```rust
let p = Point { x: 0, y: 7 };

match p {
    Point { x, y: 0 } => println!("On the x axis at {}", x),
    Point { x: 0, y } => println!("On the y axis at {}", y),    // x が 0 なのでこれにマッチ
    Point { x, y } => println!("On neither axis: ({}, {})", x, y),

    // 残りの部分を省略（無視）、タプルでも同様
    Point { y, .. } => println!("On the y axis at {}", y),
    Point { .. } => println!("all skip"),
}
```

### enumの分配
enum内に格納されているデータ定義に従って比較する必要がある。

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn main() {
    let msg = Message::ChangeColor(0, 160, 255);

    match msg {
        Message::Quit => {
            println!("The Quit variant has no data to destructure.")
        },
        Message::Move { x, y } => {
            println!("Move in the x direction {} and in the y direction {}", x, y);
        },
        Message::Write(text) => println!("Text message: {}", text),
        Message::ChangeColor(r, g, b) => {
            println!("Change the color to red {}, green {}, and blue {}", r, g, b);
        },
        _ => println!("No match"),
    }
}
```

### 参照の分配
`&` を指定することで、参照が指している値を保持する変数が得られる。\
`&` がない場合は、参照を保持する変数が得られる。（今回の場合は期待していない値）

```rust
let points = vec![
    Point { x: 0, y: 0 },
    Point { x: 1, y: 5 },
    Point { x: 10, y: -3 },
];

let sum_of_squares: i32 = points
    .iter()
    .map(|&Point { x, y }| x * x + y * y)
    .sum();

println!("sum of squares: {}", sum_of_squares);
```

※`.map` の `&Point` から `&` を消すと型不一致エラーが発生する。…はずなんだけど、 rustc 1.58.1 (db9d1b20b 2022-01-20) では発生しない。なぜ？（期待動作する）

### 構造体とタプルを分配
```rust
let ((feet, inches), Point {x, y}) = ((3, 10), Point { x: 3, y: -10 });
```

### マッチガード
`match` アームパターンの後に追加するif条件。パターンとif条件を満たす場合に実行されるようになる。\
`|` を利用して複数パターンを設定した場合、複数パターンとif条件を満たす場合に実行される。

```rust
fn main() {
    let x = Some(5);
    let y = 10;

    match x {
        Some(50) => println!("Got 50"),
        Some(n) if n == y => println!("Matched, n = {:?}", n),
        _ => println!("Default case, x = {:?}", x),
    }

    println!("at the end: x = {:?}, y = {:?}", x, y);
}
```

`if n == y` の `y` は `let y = 10` の `y` になり、シャドーイングされないので注意。

### @束縛（バインディング）
`@` 演算子により、値を保持する変数を生成すると同時に値がパターンマッチするか調べることができる。\
`変数名 @ パターン` で `match` アームパターン中に記述する。

```rust
enum Message {
    Hello { id: i32 },
}

let msg = Message::Hello { id: 5 };

match msg {
    Message::Hello { id: id_variable @ 3...7 } => {
        println!("Found an id in range: {}", id_variable)
    },
    Message::Hello { id: 10...12 } => {
        println!("Found an id in another range")
    },
    Message::Hello { id } => {
        println!("Found some other id: {}", id)
    },
}
```


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

## 借用規則
- いかなる時も(以下の両方ではなく、)1つの可変参照かいくつもの不変参照のどちらかが可能になる
- 参照は常に有効でなければならない

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

`impl` の直後に `T` を宣言しないといけないことに注意。\
（Point<T>にメソッドを実装していることを指定するために、Tを使用することができる）

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

### 関連型
関連型は、トレイトのメソッド定義がシグニチャでプレースホルダーの型を使用できるように、トレイトと型のプレースホルダーを結び付けます。\
関連型は「トレイト」と「関連型がとりえる型」が 1 対 1 になる。

```rust
impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        // --snip--
    }
}
```

ジェネリックで実装した場合、各実装で型を注釈しなければならなくなる。そのため、counter に対して next メソッドを使用する際に、どのIteratorの実装を使用したいのかの型注釈が必要となる。\
関連型なら、同じ型に対してトレイトを複数回実装できないので型を注釈する必要がない。\
　⇒Counter に next を呼び出す度に、 u32値のイテレータが欲しいと指定しなくてもよい

### スーパートレイト
あるトレイトに別のトレイトの機能を使用させる場合、依存するトレイトも実装されることを信用する必要があり、信用するトレイトは、実装しているトレイトのスーパートレイトです。

outline_print の実装で Display トレイトの機能を使用したい場合、トレイト定義で `OutlinePrint: fmt::Display` と指定することで使用することができる。

```rust
use std::fmt;

trait OutlinePrint: fmt::Display {
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
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

## イテレーター
全てのイテレータは、標準ライブラリで定義されている `Iterator` というトレイトを実装している。\
このトレイトを実装する場合は、 `Item型` と `nextメソッド` を実装する必要がある。

next を呼び出すメソッドは、消費アダプタ(consuming adaptors)と呼ばれる。（`sumメソッド` など）

```rust
#[test]
fn iterator_sum() {
    let v1 = vec![1, 2, 3];
    let v1_iter = v1.iter();
    let total: i32 = v1_iter.sum();
    assert_eq!(total, 6);
    // sumが所有権を奪っているので、v1_iter はもう使えない
}
```

### 種類
|メソッド|動作|
|:--|:--|
|iter|不変参照へのイテレータを生成|
|into_iter|所有権を奪い、所有された値を返すイテレーターを生成|
|iter_mut|可変参照へのイテレーターを生成|

### 実装例
1～5を返し、6以上は None を返すイテレータを実装する。

```rust
struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        self.count += 1;

        if self.count < 6 {
            Some(self.count)
        } else {
            None
        }
    }
}

#[test]
fn calling_next_directly() {
    let mut counter = Counter::new();

    assert_eq!(counter.next(), Some(1));
    assert_eq!(counter.next(), Some(2));
    assert_eq!(counter.next(), Some(3));
    assert_eq!(counter.next(), Some(4));
    assert_eq!(counter.next(), Some(5));
    assert_eq!(counter.next(), None);
}
```

### イテレータアダプタ(iterator adaptors)
イテレータを別の種類のイテレータに変えさせるもの。\
全てのイテレータは怠惰なので、消費アダプタメソッドのどれかを呼び出し、 イテレータアダプタの呼び出しから結果を得なければならない。

これは消費アダプタを呼び出していないので、クロージャが呼ばれることはない。（警告あり）

```rust
let v1: Vec<i32> = vec![1, 2, 3];
v1.iter().map(|x| x + 1);
```

`collectメソッド` で消費アダプタを呼び出し、イテレーターを消費する。

```rust
let v1: Vec<i32> = vec![1, 2, 3];
let v2: Vec<_> = v1.iter().map(|x| x + 1).collect();    // collectで消費
assert_eq!(v2, vec![2, 3, 4]);
```

### 環境をキャプチャするクロージャの使用
`filter` イテレータアダプタを使って環境をキャプチャするクロージャの一般的な使用例。

```rust
fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    // let mut results = Vec::new();
    // for line in contents.lines() {
    //     if line.contains(query) {
    //         results.push(line);
    //     }
    // }
    // results

    // イテレータで実装
    contents.lines()
        .filter( |line| line.contains(query) )
        .collect()
}
```

## スマートポインタ
### 再帰的な型
```
list = Cons(1, Cons(2, Cons(3, Nil)))
```

このような再帰的な構造を作る場合は `Box<T>` を使用する。

```rust
use List::{Cons, Nil};

#[derive(Debug)]
enum List {
    Cons(i32, Box<List>),
    Nil,
}

fn main() {
    // Boxを使って再帰的な型を可能にする
    let list = Cons(1, 
        Box::new(Cons(2,
            Box::new(Cons(3,
                Box::new(Nil))))));

    println!("list = {:?}", list);
}
```

### 参照のような扱い
Derefトレイトを実装して参照のように扱えるようにする。

```rust
use std::ops::Deref;

struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}

impl<T> Deref for MyBox<T> {
    // Derefトレイトが使用する関連型を定義
    type Target = T;

    fn deref(&self) -> &T {
        &self.0
    }
}

fn main() {
    let x = 5;
    let y = MyBox::new(x);
    assert_eq!(x, 5);
    assert_eq!(*y, 5);
}
```

### 暗黙的な参照外し型強制
```rust
fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&m);
}

fn hello(name: &str) {
    println!("Hello {}", name);
}
```

`hello(&m)` の部分でコンパイラは `Deref` を呼び出して、 `&MyBox<String> → &String → &str` という変換が行われる。\
（コンパイラがhello関数の定義と一致するものを Deref を呼び出して探す）

### Dropトレイト
C++などではデストラクタに相当するトレイト？\
インスタンスが解放される際に呼ばれる。

```rust
impl<T> Drop for MyBox<T> {
    fn drop(&mut self) {
        println!("Dropping MyBox!")
    }
}
```

#### 早期呼び出し
`std::mem::drop` 関数を使用して、早期に強制的にドロップさせたい値を引数で渡す。

```rust
let x = 5;
let y = MyBox::new(x);
assert_eq!(*y, 5);
std::mem::drop(y);  // 早急にドロップ
```

### 参照カウント方式
Rustには `Rc<T>` という型があり、これは、reference counting(参照カウント)の省略形。\
複数参照をしていて、コンパイル時にはどの部分が最後にデータを使用し終わるか決定できない時に `Rc<T>` 型を使用する。

```rust
use std::rc::Rc;

#[derive(Debug)]
enum List2 {
    Cons(i32, Rc<List2>),
    Nil,
}

fn main() {
    let a = Rc::new(List2::Cons(5, Rc::new(List2::Cons(10, Rc::new(List2::Nil)))));
    let b = List2::Cons(3, Rc::clone(&a));
    let c = List2::Cons(4, Rc::clone(&a));

    println!("a = {:?}", a);
    println!("b = {:?}", b);
    println!("c = {:?}", c);
    println!("reference count = {}", Rc::strong_count(&a));
}
```

結果

```
a = Cons(5, Cons(10, Nil))
b = Cons(3, Cons(5, Cons(10, Nil)))
c = Cons(4, Cons(5, Cons(10, Nil)))
reference count = 3
```

`Box<T>` を使用する代わりに `Rc<T>` を使用する。また `Rc::new` から始まることに注意。\
`Rc::clone()` はデータのディープコピーではなく、参照カウンタのインクリメントが行わるだけなのでコストは最小。

参照カウンタの数を知りたい場合は `Rc::strong_count()` を使用する。

### 内部可変性パターン
RefCell<T>型を使用して、データへの不変参照時でも可変化することができるデザインパターン。\
データ構造内で `unsafe` コードを使用しているため、マルチスレッドの文脈で使用するとコンパイルエラーとなる。
（シングルスレッド専用と考えてよい？）

`RC<T>` と組み合わせることで、普段は不変で処理し、必要な場合のみ可変にすることができる。\
ただし循環参照を生み出せてしまうため、メモリリークの危険がある。

|メソッド|動作|
|:--|:--|
|borrow|Ref<T>を返す。（不変参照）|
|borrow_mut|RefMut<T>。（可変参照）|

借用規則の確認はコンパイル時ではなく、実行時となるため、規則に違反した場合はパニックが発生する。

Messengerトレイトの send は self を不変参照しているので、`RefCell<T>` を使用せずに実装するとエラーとなる。\
そのため `RefCell<T>` で内部可変性を使用する。

```rust
pub trait Messenger {
    fn send(&self, msg: &str);
}
```
省略部分は [こちら](https://doc.rust-jp.rs/book-ja/ch15-05-interior-mutability.html) を参照。

```rust
struct MockMessenger {
    // sent_messagesをRefCell<T>に変更して内部可変性を使用する
    sent_messages: RefCell<Vec<String>>,
}

impl MockMessenger {
    fn new() -> MockMessenger {
        MockMessenger { sent_messages: RefCell::new(vec![]) }
    }
}

impl Messenger for MockMessenger {
    fn send(&self, message: &str) {
        // RefCell<Vec<String>>の中の値への可変参照を得て文字列を設定する
        self.sent_messages.borrow_mut().push(String::from(message));
    }
}

#[test]
fn it_sends_an_over_75_percent_warning_message() {
    let mock_messenger = MockMessenger::new();
    let mut limit_tracker = LimitTracker::new(&mock_messenger, 100);

    limit_tracker.set_value(80);

    // borrowを呼び出しベクタへの不変参照を得て、ベクタにある要素数を確認
    assert_eq!(mock_messenger.sent_messages.borrow().len(), 1);
}
```

#### 循環参照の回避
循環参照になる部分の `Rc<T>` を `Rc::downgrade` を使用し `Weak<T>` を取得する。
弱い参照(weak reference)は参照カウント方式だが、`Rc<T>` の `strong_count` が0になると、`weak_count` が残っていても `Rc<T>` が型付けられるため、循環参照にならない。ただし、`Weak<T>` の参照する値がドロップしている可能性があるため、使用する際は `Weak<T>` の `upgrade` メソッドを呼び出す必要がある。

```rust
use std::rc::{Rc, Weak};
use std::cell::RefCell;

#[derive(Debug)]
struct Node {
    value: i32,
    parent: RefCell<Weak<Node>>,
    children: RefCell<Vec<Rc<Node>>>,
}

fn main() {
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });

    // leafの親 = {:?}
    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());

    let branch = Rc::new(Node {
        value: 5,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![Rc::clone(&leaf)]),
    });

    *leaf.parent.borrow_mut() = Rc::downgrade(&branch);

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());
}
```

出力結果。（循環参照をしていないことを確認）

```
leaf parent = None
leaf parent = Some(Node { value: 5, parent: RefCell { value: (Weak) }, children: RefCell { value: [Node { value: 3, parent: RefCell { value: (Weak) }, children: RefCell { value: [] } }] } })
```

## スレッド
### thread::spawn関数
`thread::spawn()` にクロージャを渡して並列化。\
ハンドルに対して `join` を呼び出すと、ハンドルが表すスレッドが終了するまで現在実行中のスレッドをブロックする。

```rust
use std::thread;

// スレッド作成
let = handle = thread::spawn(|| {
    println!("the spawned thread!");
});

// スレッド終了待ち
handle.join().unwrap();
```

#### moveクロージャの使用
moveクロージャによる所有権の移動は、あるスレッドから別のスレッドに値の所有権を移すために新しいスレッドを生成する際に有用。

```rust
let v = vec![1, 2, 3];

// move でクロージャに所有権を移動
let handle = thread::spawn(move || {
    println!("Here's a vector: {:?}", v);
});

//drop(v);  // 所有権がスレッドに移っているのでエラーとなる

handle.join().unwrap();
```

### メッセージの受け渡しを使用してスレッド間でデータを転送
`mpsc::channel` 関数はタプルを返し、1つ目の要素は送信側、2つ目の要素は受信側になる。\
`tx.send` で所有権が送信機に移っているので注意！

```rust
use std::thread;
use std::sync::mpsc;

fn main() {
    // txとrxは転送機と受信機の略称
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("Hi");
        tx.send(val).unwrap();  // 転送
    });

    let received = rx.recv().unwrap();  // 受信
    println!("Got: {}", received);
}
```

`rx.recv()` はメインスレッドの実行をブロックし、値がチャンネルに流れてくるまで待機。\
`rx.try_recv()` はブロックせず、即座に `Result<T, E>` を返す。（メッセージがあればそれを含むOk、なければErr値）

#### 複数の送信機から受信
`mpsc::Sender::clone` 関数を使用して送信機を複製する。受信機はイテレーターとして扱う。チャンネルが閉じると繰り返しが終わる。

```rust
use std::thread;
use std::time::Duration;
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    let tx1 = mpsc::Sender::clone(&tx);
    thread::spawn(move || {
        let vals = vec![
            String::from("hi"),
            String::from("from"),
            String::from("the"),
            String::from("thread"),
        ];

        for val in vals {
            tx1.send(val).unwrap();  // tx1 で転送
            thread::sleep(Duration::from_secs(1));
        }
    });

    thread::spawn(move || {
        let vals = vec![
            String::from("more"),
            String::from("message"),
            String::from("for"),
            String::from("you"),
        ];

        for val in vals {
            tx.send(val).unwrap();  // tx で転送
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {    // イテレーターで複数受信
        println!("Got: {}", received);
    }
}
```

### Mutex（ミューテックス）
ミューテックスの対象になる値を `Mutex<T>` で作成する。\
`lock` メソッドで値のロックを試み、`MutexGuard` というスマートポインタを取得できる。\
これを使用して、内部の値を変更することとなる。

Mutexは便利だけど、デッドロックを発生させることがあるので、取り扱いには注意が必要。

```rust
let m = Mutex::new(5);
{
    let mut num = m.lock().unwrap();
    *num = 6;
}
println!("m = {:?}", m);
//m = Mutex { data: 6, poisoned: false, .. }
```

#### 複数のスレッドで Mutex を使用する場合
`thread::spawn` に渡すクロージャで所有権が移ってしまうため、上記をそのまま使用することができない。\
複数参照として `Rc<T>` がありますが、スレッドセーフではないためコンパイルエラーになる。\
`Rc<T>` のスレッドセーフである `Arc<T>` を使うことで問題を解決できる。

※A=Atomic

```rust
use std::thread;
use std::sync::{Mutex, Arc};

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

### Sync と Send トレイト
- Send
  - スレッド間の所有権の許可する
  - Rustのほとんどの型は `Send` を実装しているが、 `Rc<T>` の様に一部例外あり
- Sync
  - 複数スレッドからのアクセスを許可する
  - `Sync` を実装した型は、複数スレッドからアクセスされても安全となる（スレッドセーフ）

基本的に手動で実装する必要はないが、実装する場合は `unsafe` なRustコードを実装する必要がある。

## ダックタイピング
対象となるトレイトの実装ではなく、同じ型の異なるコードを実装した場合でも、トレイトを実装したオブジェクトから呼び出すことができる。\
何故なら、同じ型のメソッドを実装しているからである。Rustは動的型付け言語のダックタイピングと似た概念を実装しているからである。

Buttonオブジェクトは Draw型 を実装していないが、drawメソッドを実装しているため、Screenからdrawメソッドを呼び出せる。\
　⇒値がトレイトオブジェクトが必要としているトレイトを実装していなければ、コンパイルエラーになる

```rust
pub trait Draw {
    fn draw(&self);
}

pub struct Screen {
    pub components: Vec<Box<dyn Draw>>,
}

impl Screen {
    pub fn run(&self) {
        for component in self.components.iter() {
            component.draw();
        }
    }
}

pub struct Button {
    pub width: u32,
    pub height: u32,
    pub label: String,
}

impl Draw for Button {
    fn draw(&self) {
        println!("Draw for Button");
        println!(" width : {}", self.width);
        println!(" height: {}", self.height);
        println!(" label : {}", self.label);
    }
}

pub fn gui_test() {
    let screen = Screen {
        components: vec![
            Box::new(Button {
                width: 50,
                height: 10,
                label: String::from("OK"),
            }),
        ],
    };
    screen.run();
}
```

## unsafe
### 生ポインタの参照外し
`unsafe` の外で参照外しをした場合はコンパイルエラーとなる。

```rust
let mut num = 5;

let r1 = &num as *const i32;
let r2 = &mut num as *mut i32;
unsafe {
    *r2 = 10;
    println!("r1={}, r2={}", *r1, *r2);
}
```

### unsafeな関数やメソッドの呼び出し
`unsafe` の外でunsafeな関数やメソッドを呼び出した場合はコンパイルエラーとなる。

```rust
unsafe fn dangerous() {}
unsafe {
    dangerous();
}
```

#### 内部の一部でunsafeを使用
`unsafe` を関数やメソッドの内部の一部で使う場合、その関数やメソッドは `safe` として（通常と同じ様に）呼ぶことができる。

```rust
fn hoge {
    ...
    unsafe {
        ...
    }
}

fn main() {
    hoge();
}
```

### mutable static variable
`static mut` 変数の読み書きは `unsafe` ブロックの中でしかできない

```rust
static mut COUNTER: u32 = 0;

fn main() {
    unsafe {
        COUNTER += 3;
        println!("counter: {}", COUNTER);
    }
}
```

## 関数ポインタ
クロージャを使わず、普通の関数を関数の引数に渡すことができる。関数ポインタは、クロージャトレイト3つ全て(Fn、FnMut、FnOnce)を実装するので、常に関数ポインタを引数として、 クロージャを期待する関数に渡すことができます。

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}

fn do_twice(f: fn(i32) -> i32, arg: i32) -> i32 {
    f(arg) + f(arg)
}

fn main() {
    let answer = do_twice(add_one, 5);
    println!("The answer is: {}", answer);
}
```

## マクロ
マクロには以下のデメリットがあるのであまり利用しない方がよいとされている。

- コードが理解しづらい
- 良いマクロを書くのは難しい
- コンパイルエラーは展開後のコードで起こるので、原因が分かり難い

詳しくは参考HPを参照。ここでは自分が使ったことのあるものをピックアップ。

### 基本形
```Rust
macro_rules! foo {
    () => ()
}

foo!();  // 何もしない
```

### 指定子
name:disanatorの形式で、何にマッチさせるか（disanator）と、マッチさせたものを格納するメタ変数(name:disanator)の形式で、
何にマッチさせるか（disanator）と、マッチさせたものを格納するメタ変数(name）を指定できる。

|指定子|マッチするもの|
|:--|:--|
|item|アイテム（関数、構造体など）|
|block|ブロック|
|stmt|ステートメント（文）|
|pat|パターン|
|expr|式|
|ty|型|
|ident|識別子|
|path|修飾された名前|
|tt|単一のトークン木|
|meta|アトリビュートの中身|

#### item
- extern crate 宣言
- use 宣言
- モジュール
- 関数
- 型定義
- 構造体 (struct)
- 列挙子 (enum)
- 定数 (const)
- 静的アイテム (static)
- トレイト (trait)
- トレイトの実装 (impl ... for ... { ... })

#### expr
式にマッチする。Rustは式ベースなので、計算や関数の結果、if文やブロックなどが該当する。

```Rust
macro_rules! match_expr {
    ( $e:expr ) => (println!("expr: {}", stringify!($e)))
};

match_expr!(10);
match_expr!(line.unwrap());
match_expr!(if initialized { start() } else { report_error() });
```

#### ty
型にマッチする。マクロの展開はコンパイル前に行われるので、既知の型でなくてもいい。

```Rust
macro_rules! match_ty {
    ( $t:ty ) => (println!("ty: {}", stringify!($t)))
};

match_ty!(i32);
match_ty!(String);
match_ty!(&[i32]);
match_ty!(UnknownType);  // 未知の型
match_ty!(html);  // 頭小文字の未知の型
match_ty!(std::str);  // パス付き
```

#### ident
識別子にマッチする。こちらは ty と違って予約語でもマッチする。

```Rust
#[macro_export]
macro_rules! match_ident {
    ( $i:ident ) => (println!("ident: {}", stringify!($i)))
};

match_ident!(i32);
match_ident!(String);
match_ident!(UnknownType);
match_ident!(match);
match_ident!(if);
match_ident!(fn);
```

`#[macro_export]` があると、マクロを定義しているクレートがスコープに持ち込まれたなら、無条件でこのマクロが利用可能になる。
これがないとマクロがスコープに持ち込まれない（非公開）になる。

### 参考HP
[Rustのマクロを覚える](https://qiita.com/k5n/items/758111b12740600cc58f)

## コマンドラインオプション
公式トレントにある `getopts` を使用すると楽ができる。\
基本的な機能が提供されているので、難しい処理をしなければ十分使える。

### 使い方
[ドキュメント参照](https://docs.rs/getopts/0.2.21/getopts/)。

## 色付きの標準出力
エスケープシーケンスを使うと色を付けて出力可能。\
Rustでは16進数の `\x1b` しか利用できない。

|文字色|背景色|色|
|:--|:--|:--|
|\\x1b[30m|\\x1b[40m|黒|
|\\x1b[31m|\\x1b[41m|赤|
|\\x1b[32m|\\x1b[42m|緑|
|\\x1b[33m|\\x1b[43m|黄|
|\\x1b[34m|\\x1b[44m|青|
|\\x1b[35m|\\x1b[45m|マゼンダ|
|\\x1b[36m|\\x1b[46m|シアン|
|\\x1b[37m|\\x1b[47m|白|

### 出力色の変更（拡張）
`\e[38;5;nm` の `n` を `0～255` を指定することで256色を指定可能。\
環境によっては対応していない場合がある。

例）
```Rust
println!("\e[38;5;85mテストコード");
```

## メモ
- コメント以外で日本語があるとコンパイルに失敗する場合がある
- `_` はワイルドカードで、オブジェクトを無視するときに使用する
  ```rust
  let guess: u32 = match guess.trim().parse() {
      Ok(num) => num,
      Err(_) => return,
  };
  ```
  ```rust
  fn foo(_: i32, y: i32) {
    println!("This code only uses the y parameter: {}", y);
  }
  ```
- `_` + 変数名で未使用変数の警告を抑制できる
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
- フルパス記法
  - `<Type as Trait>::function(receiver_if_method, next_arg, ...);`
- `type 型名 = 型` で型のエイリアスを定義が可能
  - C言語の `typedef` と似た機能
- `!` は Empty型 と呼ばれ、絶対値を返さない戻値型
  - `continue` などで暗黙的に使われている
  - `fn hoge() -> ! {` と明示的に使うことも可能

## 参考HP
- [The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/title-page.html)
- [Rust入門](https://zenn.dev/mebiusbox/books/22d4c2ed9b0003/viewer/6d5875)


