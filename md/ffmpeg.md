# ffmpegのメモ

## 入手先
### Windows
[公式サイト](http://www.ffmpeg.org/) の Download から入手。

### Linux
パッケージ管理から取得可能。

## よく使うオプション
### 共通
|オプション|動作|
|:--|:--|
|-i|入力ファイルの指定（m3u8のURLに対応）|
|-f|変換フォーマットの指定|
|-c copy|映像と音声をコピーする|
|-t|切り取る時間(秒)|
|-fs|出力サイズの制限|
|-ss|時間指定のオフセット|
|-ssof|最後からのオフセット|
|-y|上書き保存|

### 映像
|オプション|動作|
|:--|:--|
|-r|フレームレートの指定|
|-b|ビットレートの指定|
|-s|解像度の指定|
|-aspect|アスペクト比の指定|
|-vcodec|コーデックの指定（-codec:v のalias）|
|-vf|エフェクトの内容を指定|
|-vn|ビデオ出力無効|

### 音声
|オプション|動作|
|:--|:--|
|-acodec|コーデックの指定（-codec:a のalias）|
|-b:a|ビットレートを指定|
|-ac|チャンネル数を指定|
|-vol|音量を指定|
|-ar|サンプリングレートを指定|
|-an|音声出力無効|


## 変換
### 基本
```bash
$ ffmpeg -i <input file> <output file>
```

### 対応コーデック確認
```bash
$ ffmpeg -codecs
```

### 対応フォーマット確認
```bash
$ ffmpeg -formats
```

### フレームレート指定
```bash
$ ffmpeg -i input.mp4 -r 30 output.mp4
```

### サイズ指定
```bash
$ ffmpeg -i input.mp4 -s 1280x720 output.mp4
```

#### ビットレート指定
```bash
$ ffmpeg -i input.mp4 -b:v 6000k output.mp4
```

ビットレートの上限設定。\
上限を設定する場合はバッファの設定が必要。

```bash
$ ffmpeg -i input.mp4 -b:v 2000k -maxrate 2500k -bufsize 2000k output.mp4
```

ビットレートの上下限を設定。

```bash
$ ffmpeg -i input.mp4 -b:v 2000k -minrate 1800k -maxrate 2200k -bufsize 2000k output.mp4
```

### アスペクト比指定
```bash
$ ffmpeg -i input.mp4 -aspect 16:9 output.mp4
```

アスペクト比だけ変換。

```bash
$ ffmpeg -i input.mp4 -c copy -aspect 16:9 output.mp4
```

### 回転
※ ":s:v:0": 最初のビデオストリーム

#### 時計回りに90度
```bash
$ ffmepg -i input.mp4 -c copy -metadata:s:v:0 rotate=-90 output.mp4
```

#### 反時計回りに90度
```bash
$ ffmepg -i input.mp4 -c copy -metadata:s:v:0 rotate=90 output.mp4
```

### 連番画像出力
10フレーム分を出力。\
フレーム指定省略ですべてのフレーム出力。

```bash
$ ffmpeg -i input.mp4 -frames:v 10 output/frame%03d.jpg
```

途中からの場合は先頭位置を指定する。

```bash
$ ffmpeg -i input.mp4 -ss 60 -frames:v 10 output/frame%03d.jpg
```

### 連番から動画に変換
```bash
$ ffmpeg -i ./output/frame%03d.jpg -vcodec libx264 -qscale:v 0 output.mp4
```

### 無変換
```bash
$ ffmpeg -i input.mp4 -codec copy output.mp4
```

時間指定やフレーム指定と併用して部分出力などをするときに使う。

```bash
$ ffmpeg -i input.mp4 -codec copy -ss 00:00:10.0 -t 10 output.mp4
```

### 動画と音声の抽出
```bash
# 動画から映像のみを出力
$ ffmpeg -i input.mp4 -vcodec copy -an output_nosound.mp4

# 動画から音声のみを出力
$ ffmpeg -i input.mp4 -acodec copy -vn output_sound.aac
```

### 無音の追加
```bash
# 頭に10秒の無音追加
$ ffmpeg -i input.mp4 -vf tpad=start_duration=10:color=black -af "adelay=10s:all=1" output.mp4

# お尻に10秒の無音追加
$ ffmpeg -i input.mp4 -vf tpad=stop_duration=10:color=black -af "apad=pad_dur=11" output.mp4
```

### 2passエンコード
```bash
$ ffmpeg -i input.avi -b:v 2000k -pass 1 -an output.mp4
$ ffmpeg -i input.avi -b:v 2000k -pass 2 -y output.mp4
```

### video quantizer scale (VBR)
#### min
デフォルトは`2`だが、小さすぎるので`10以上`が望ましい。

```bash
$ ffmpeg -i imput.mp4 -qmin <-1～69> output.mp4
```

#### max
デフォルトは`31`。

```bash
$ ffmpeg -i imput.mp4 -qmax <-1～1024> output.mp4
```

### H.264
#### 基本
```bash
$ ffmpeg -i input.mp4 -codec:v libx264 output.mp4
```

#### 品質固定
小さいほど高画質。\
`crf` のデフォルトは 23 で、18～28 が推奨されている。

```bash
$ ffmpeg -i input.mp4 -codec:v libx264 -crf <18～28> output.mp4
```

#### プリセット
```bash
$ ffmpeg -i input.mp4 -codec:v libx264 -preset <preset> -tune <tune> output.mp4
```

- preset
  - ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo
  - 左ほど変換速度が速く、右ほど時間がかかるがファイルサイズが小さくなる
- tune
  - 指定の省略可能
  - film: 実写向け 
  - animation: アニメ向け
  - grain: 古い動画向け
  - stillimage: スライドなど動きのない動画向け

### H.265(HEVC)
#### 基本
```bash
$ ffmpeg -i input.mp4 -codec:v libx265 output.mp4
```

#### 品質固定
小さいほど高画質。\
`crf` のデフォルトは 28 で、H.264のデフォルト値 23 と同党の画質となる。

```bash
$ ffmpeg -i input.mp4 -codec:v libx265 -crf <0～51> output.mp4
```

#### プリセット
```bash
$ ffmpeg -i input.mp4 -codec:v libx265 -preset <preset> -tune <tune> output.mp4
```

- preset
  - ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo
  - 左ほど変換速度が速く、右ほど時間がかかるがファイルサイズが小さくなる
- tune
  - 指定の省略可能
  - psnr: ???(2つの入力ビデオ間の平均、最大、および最小のPSNR（ピーク信号対雑音比）を取得)
  - ssim: ???(2つの入力ビデオ間のSSIM（Structural SImilarity Metric）を取得)
  - animation: アニメ向け
  - grain: 古い動画向け

#### 変換例
##### 映像変換、音声変換なし
```bash
$ ffmpeg -i input.mp4 -codec:v libx265 -crf 20 -tune animation -b:v 1000k -maxrate 1000k -bufsize 2000k -codec:a copy output.mp4
```

##### 映像・音声変換
```bash
$ ffmpeg -i input.mp4 -codec:v libx265 -crf 20 -tune animation -b:v 1000k -maxrate 1000k -bufsize 2000k -codec:a libmp3lame -b:a 128k -q:a 3 output.mp4
```

### 音声変換
```bash
# MP3(固定ビットレート(-b:a), 可変ビットレート(-q:a 0～9))
$ ffmpeg -i input.mp4 -acodec libmp3lame -b:a <128～320K> output.mp3

# AAC
$ ffmpeg -i input.mp4 -acodec libfdk_aac -b:a <128～320K> output.aac
```

Windowsバイナリには `libfdk_aac` がないので以下を指定する。\
コーデック的には音質が少し落ちるらしい。

```bash
$ ffmpeg -i input.mp4 -acodec aac -strict -2 -b:a <128～320K> -nv output.aac
```

## 対応確認
### コーデック
```bash
$ ffmpeg -codecs
$ ffmpeg -codecs | grep 264
```

### エンコーダー
```bash
$ ffmpeg -encoders
$ ffmpeg -encoders | grep 264
```

### デコーダー
```bash
$ ffmpeg -decoders
$ ffmpeg -decoders | grep 264
```

## メモ
### AV1でエンコード
10世代Core i5(6コア12スレッド)でものすごい時間がかるぐらいエンコードが遅い。\
スレッド指定してもCPU負荷が増えないのでライブラリの問題？

```bash
# 映像のみ
$ ffmpeg -i input.mp4 -codec:v libaom-av1 -crf 20 -strict -2 output.webm

# 映像+音声
$ ffmpeg -i input.mp4 -threads 8 -codec:v libaom-av1 -crf 20 -b:v 1000k -maxrate 1000k -bufsize 3000k -strict -2 -codec:a libopus -b:a 128k output.webm
```

### スレッド指定
明示的に指定する場合は `-threads` で使用するスレッド数を指定できる。\
指定がない場合は ffmepg がいい感じに対応してくれる。

```bash
$ ffmpeg -i input.mp4 -codec:v libaom-av1 -crf 18 -strict -2 -threads 8 output.webm
```

## 参考HP
- [【初心者向け】FFmpegの使い方を分かりやすく解説！ダウンロードとインストール方法もあり！ | 動画初心者の部屋](https://videobeginners.com/how-to-use-ffmpeg/)
- [ffmpegの使い方](https://tech.ckme.co.jp/ffmpeg.shtml)
- [最新ffmpeg/高度なオプション - MobileHackerz Knowledgebase Wiki](http://mobilehackerz.jp/archive/wiki/index.php?%BA%C7%BF%B7ffmpeg%2F%B9%E2%C5%D9%A4%CA%A5%AA%A5%D7%A5%B7%A5%E7%A5%F3)

