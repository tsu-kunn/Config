# gstreamerのメモ

## 対応しているエレメント取得
Raspberry Pi 4B で取得した例。

### MPEG-TS
```
pi@raspberrypi:~ $ gst-inspect-1.0 | grep -ie mpegts
mpegtsdemux:  tsdemux: MPEG transport stream demuxer
mpegtsdemux:  tsparse: MPEG transport stream parser
typefindfunctions: video/mpegts: ts, mts
libav:  avmux_mpegts: libav MPEG-TS (MPEG-2 Transport Stream) muxer (not recommended, use mpegtsmux instead)
mpegtsmux:  mpegtsmux: MPEG Transport Stream Muxer
```

### MPEG2
```
pi@raspberrypi:~ $ gst-inspect-1.0 | grep -ie mpeg2
mpeg2dec:  mpeg2dec: mpeg1 and mpeg2 video decoder
rtp:  rtpmpvpay: RTP MPEG2 ES video payloader
rtp:  rtpmp2tpay: RTP MPEG2 Transport Stream payloader
libav:  avenc_mpeg2video: libav MPEG-2 video encoder
libav:  avdec_mpeg2video: libav MPEG-2 video decoder
libav:  avdec_mpeg2_mmal: libav mpeg2 (mmal) decoder
mpeg2enc:  mpeg2enc: mpeg2enc video encoder
omx:  omxmpeg2videodec: OpenMAX MPEG2 Video Decoder
```

### h264
```
pi@raspberrypi:~/Downloads $ gst-inspect-1.0 | grep -ie h264
video4linux2:  v4l2h264dec: V4L2 H264 Decoder
video4linux2:  v4l2h264enc: V4L2 H.264 Encoder
typefindfunctions: video/x-h264: h264, x264, 264
rtp:  rtph264pay: RTP H264 payloader
rtp:  rtph264depay: RTP H264 depayloader
videoparsersbad:  h264parse: H.264 parser
libav:  avdec_h264_mmal: libav h264 (mmal) decoder
libav:  avdec_h264: libav H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 decoder
libav:  avenc_h264_omx: libav OpenMAX IL H.264 video encoder encoder
uvch264:  uvch264src: UVC H264 Source
uvch264:  uvch264mjpgdemux: UVC H264 MJPG Demuxer
omx:  omxh264enc: OpenMAX H.264 Video Encoder
omx:  omxh264dec: OpenMAX H.264 Video Decoder

pi@raspberrypi:~ $ gst-inspect-1.0 | grep -ie x264
x264:  x264enc: x264enc
typefindfunctions: video/x-h264: h264, x264, 264
```

### h265
```
pi@raspberrypi:~ $ gst-inspect-1.0 | grep -ie h265
typefindfunctions: video/x-h265: h265, x265, 265
rtp:  rtph265pay: RTP H265 payloader
rtp:  rtph265depay: RTP H265 depayloader
videoparsersbad:  h265parse: H.265 parser
libav:  avdec_h265: libav HEVC (High Efficiency Video Coding) decoder

pi@raspberrypi:~ $ gst-inspect-1.0 | grep -ie x265
typefindfunctions: video/x-h265: h265, x265, 265
```

### MPEG4
```
pi@raspberrypi:~/Downloads $ gst-inspect-1.0 | grep -i MPEG-4
libav:  avenc_mpeg4: libav MPEG-4 part 2 encoder
libav:  avenc_msmpeg4v2: libav MPEG-4 part 2 Microsoft variant version 2 encoder
libav:  avenc_msmpeg4: libav MPEG-4 part 2 Microsoft variant version 3 encoder
libav:  avdec_als: libav MPEG-4 Audio Lossless Coding (ALS) decoder
libav:  avdec_h264: libav H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 decoder
libav:  avdec_mpeg4: libav MPEG-4 part 2 decoder
libav:  avdec_msmpeg4v1: libav MPEG-4 part 2 Microsoft variant version 1 decoder
libav:  avdec_msmpeg4v2: libav MPEG-4 part 2 Microsoft variant version 2 decoder
libav:  avdec_msmpeg4: libav MPEG-4 part 2 Microsoft variant version 3 decoder
libav:  avmux_ipod: libav iPod H.264 MP4 (MPEG-4 Part 14) muxer
libav:  avmux_mp4: libav MP4 (MPEG-4 Part 14) muxer (not recommended, use mp4mux instead)
libav:  avmux_psp: libav PSP MP4 (MPEG-4 Part 14) muxer
```


## コマンド例
### MPEG2-TS(RTP over RTSP)
```bash
$ ./test-launch '( filesrc location=fire.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! mpegtsmux ! rtpmp2tpay  name=pay0 pt=33 )'
$ ./test-launch '( filesrc location=H265_Mov.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h265parse ! mpegtsmux ! rtpmp2tpay  name=pay0 pt=33 )'
```

### MPEG2TS over UDP
```bash
$ gst-launch-1.0 videotestsrc ! video/x-raw,width=640,height=360,framerate=30/1 ! x264enc ! mpegtsmux ! udpsink host=192.168.0.150 port=8554

# ファイル指定（ループせず終わる）
$ gst-launch-1.0 filesrc location=fire.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! mpegtsmux ! udpsink host=192.168.0.150 port=1234
$ gst-launch-1.0 filesrc location=H265_Mov.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h265parse ! mpegtsmux ! udpsink host=192.168.0.150 port=1234
```

### Debug実行
```bash
$ GST_DEBUG=3 ./test-launch '( videotestsrc ! x264enc ! queue ! h264parse ! mpegtsmux ! rtpmp2tpay  name=pay0 pt=33 )'
$ GST_DEBUG=3 ./test-launch '( videotestsrc ! x265enc ! queue ! h265parse ! mpegtsmux ! rtpmp2tpay  name=pay0 pt=33 )'
```

### 試行錯誤
動作するもの、動作しないものもある。\
これらの結果からコマンド例のコマンドが導き出された。

```
gst-launch-1.0 -v videotestsrc ! x264enc ! avdec_h264 ! videoconvert ! autovideosink
gst-launch-1.0 -v videotestsrc ! x264enc ! rtph264pay ! udpsink host=127.0.0.1 port=5005 sync=false

gst-launch-1.0 -e videotestsrc ! video/x-raw,format=NV12,width=640,height=480,framerate=30/1 ! x264enc ! queue ! qtmux ! filesink location=test.mp4

gst-launch-1.0 filesrc location=test.ts ! progressreport ! tsdemux name=demuxer demuxer. ! queue ! mux. mp4mux  name=mux ! filesink location=test.mp4 demuxer. ! queue ! mpegvideoparse ! omxmpeg2videodec ! videoconvert ! omxh264enc ! video/x-h264 ! h264parse ! mux.

./test-launch '( videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96 )'
./test-launch '( filesrc location=fire.mp4 ! qtdemux name=demux demux.video_0 ! queue ! rtph264pay name=pay0 pt=96 )'
./test-launch '( filesrc location=fire.mp4 ! qtdemux name=demux demux.video_0 ! queue ! rtph264pay name=pay0 pt=96 ! h264parse ! mpegtsmux)'

gst-launch-1.0 -e mpegtsmux name=mux ! udpsink port=8554 \
videotestsrc is-live=true ! 'video/x-raw,format=(string)I420,width=320,height=240,framerate=(fraction)30/1' ! x264enc ! mux.

./test-launch '( videotestsrc ! video/x-raw,width=640,height=360,framerate=30/1 ! x264enc ! mpegtsmux )'

gst-launch-1.0 filesrc location=fire.mp4 ! video/x-h264,width=640,height=360,framerate=30/1 ! h264parse ! mpegtsmux ! udpsink host=192.168.0.150 port=8554
gst-launch-1.0 filesrc location=fire.mp4 ! h264parse ! mpegtsmux ! udpsink host=192.168.0.150 port=8554

gst-launch-1.0 rtspsrc location="rtsp://192.168.0.231:554/ONVIF/MediaInput?profile=def_profile2" user-id=admin user-pw=_Fdf2304 ! rtph264depay ! h264parse ! mpegtsmux ! udpsink host=192.168.0.150 port=8554
```

## gst-rtsp-serverのインストール
### GitHubから取得
[GStreamer/gst-rtsp-server](https://github.com/GStreamer/gst-rtsp-server)

```bash
$ git clone https://github.com/GStreamer/gst-rtsp-server.git
$ cd gst-rtsp-server
```

### gstreamerと同じバージョンのブランチをチェックアウト
#### gstreamerのバージョン確認
```bash
$ gst-launch-1.0 --version
```

#### チェックアウト
```
$ git checkout <gstreamerのバージョン>

# 例
$ git checkout 1.6.2
```

### コンパイルとインストール
#### 必要になるパッケージをインストール
```bash
$ sudo apt-get install gtk-doc-tools
```

#### Commonの取得先をGitHubに変更
`.gitmodules` のURLを以下に書き換える。

```
url = https://github.com/GStreamer/common
```

`.git/config` の `[submodule "common"]` のURLを以下に書き換える。

```
url = https://github.com/GStreamer/common
```

#### コンパイル＆インストール
```bash
$ ./autogen.sh
$ make
$ sudo make install
```

### 簡易RTSPサーバー
`example/.test-launch` を使用する。\
`filesrc location` に指定するファイルは直下にないとダメそう。\
（絶対パス、相対パスで記載したらファイルが見つからないとエラーになった）

## 動画の保存
`filesink` で出力先をファイルにできる。

```bash
$ gst-launch-1.0 videotestsrc ! x265enc ! queue ! h265parse ! mpegtsmux ! filesink location=test.mp4
```

H.265にエンコードしてMPEG2-TSとして保存。\
Mediainfoで確認すると以下になる


```
General
ID                                       : 1 (0x1)
Complete name                            : test.mp4
Format                                   : MPEG-TS
File size                                : 6.76 MiB
Duration                                 : 34 s 167 ms
Overall bit rate mode                    : Variable
Overall bit rate                         : 1 653 kb/s
FileExtension_Invalid                    : ts m2t m2s m4t m4s tmf ts tp trp ty

Video
ID                                       : 65 (0x41)
Menu ID                                  : 1 (0x1)
Format                                   : HEVC
Format/Info                              : High Efficiency Video Coding
Format profile                           : Main@L2.1@Main
Codec ID                                 : 36
Duration                                 : 34 s 166 ms
Bit rate                                 : 1 572 kb/s
Width                                    : 320 pixels
Height                                   : 240 pixels
Display aspect ratio                     : 4:3
Frame rate                               : 30.000 FPS
Color space                              : YUV
Chroma subsampling                       : 4:2:0
Bit depth                                : 8 bits
Bits/(Pixel*Frame)                       : 0.682
Stream size                              : 6.40 MiB (95%)
```

### H.264の動画をH.265にエンコードして保存
`filesink` 前に `mux` で終わらないと再生できない動画になる。\
`x264enc` は mux に直でつながるが、`x265enc` は直でつながらないため `h265parse` を経由している。\

```bash
# Format profile: QuickTime
$ gst-launch-1.0 filesrc location="fire.mp4" ! qtdemux ! queue ! avdec_h264 ! x265enc ! h265parse ! qtmux ! filesink location="test.mp4"

# Format profile: Base Media / Version 2
$ gst-launch-1.0 filesrc location="fire.mp4" ! qtdemux ! queue ! avdec_h264 ! x265enc ! h265parse ! mp4mux ! filesink location="test.mp4"
```

### リサイズとビットレート指定
`videoscale` を指定することでリサイズできることを確認。

```bash
$ gst-launch-1.0 filesrc location="fire.mp4" ! qtdemux ! queue ! avdec_h264 ! videoscale ! video/x-raw,width=1280,height=720 ! x265enc bitrate=4000 ! h265parse ! mp4mux ! filesink location="test.mp4"
```

### フレームレート指定
`videorate` を指定することでフレームレートを変更できることを確認。

```bash
$ gst-launch-1.0 filesrc location="fire.mp4" ! qtdemux ! queue ! avdec_h264 ! videoscale ! video/x-raw,width=1280,height=720 ! videorate ! video/x-raw,framerate=15/1 ! x265enc bitrate=3000 ! h265parse ! mp4mux ! filesink location="test.mp4"
```

## 画像の保存
デコードした後に `videoconvert` でPNGに変換できる形式にするのがポイント。

### スナップショット
```bash
$ gst-launch-1.0 filesrc location="fire.mp4" ! decodebin ! videoconvert ! pngenc snapshot=true ! filesink location="test.png"
$ gst-launch-1.0 filesrc location="fire.mp4" ! qtdemux ! queue ! avdec_h264 ! videoconvert ! pngenc snapshot=true ! filesink location="test.png"
```

### 連番画像
```bash
$ gst-launch-1.0 filesrc location="fire.mp4" ! decodebin ! videoconvert ! pngenc ! multifilesink location=output/img%d.png
$ gst-launch-1.0 filesrc location="fire.mp4" ! qtdemux ! queue ! avdec_h264 ! videoconvert ! pngenc ! multifilesink location="output/img%d.png"
```

## 再生
※未確認

```bash
$ gst-launch-1.0 playbin uri=file://.../hoge.oga
$ gst-launch-1.0 playbin uri=file://.../hoge.mpg
```

## 音声の変換
### AAC
```bash
$ gst-launch-1.0 filesrc location="input.mp4" ! qtdemux ! queue ! avdec_aac ! audioconvert ! avenc_aac ! qtmux ! filesink location="output.m4a"
```
#### ビットレート指定
```bash
$ gst-launch-1.0 filesrc location="input.mp4" ! qtdemux ! queue ! avdec_aac ! audioconvert ! avenc_aac bitrate=64000 ! qtmux ! filesink location="output.m4a"
```

### MP3
#### 可変レート（default）
```bash
$ gst-launch-1.0 filesrc location="Arcnights.mp4" ! qtdemux ! queue ! avdec_aac ! audioconvert ! lamemp3enc bitrate=128 quality=3 ! avmux_mp3 
! filesink location="output.mp3"
```

#### 固定レート
```bash
$ gst-launch-1.0 filesrc location="Arcnights.mp4" ! qtdemux ! queue ! avdec_aac ! audioconvert ! lamemp3enc bitrate=64 cbr=true target=1 ! avmux_mp3 ! filesink location="output.mp3"
```

## 動画+音声の変換
### テストデータ
```bash
gst-launch-1.0 -e videotestsrc ! video/x-raw,format=NV12,width=640,height=480,framerate=30/1 ! x264enc ! queue ! muxer. audiotestsrc wave=sine freq=1000 ! audio/x-raw,format=F32LE,layout=interleaved,rate=48000,channels=2 ! avenc_aac ! queue ! muxer. qtmux name="muxer" ! filesink location=sample.mp4
```

### ファイル
※ 未完成（"Redistribute latency..." で止まってしまう…）

```bash
$ gst-launch-1.0 filesrc location="sample.mp4" ! progressreport ! qtdemux name=demux demux. ! queue ! aacparse ! avdec_aac ! audioresample ! audioconvert dithering=0 ! lamemp3enc bitrate=64 quality=3 ! mux. qtmux name=mux ! filesink location="test.mp4" demux. ! queue ! h264parse ! avdec_h264 ! x265enc ! h265parse ! mux.
```

### 動画無変換（音声のみ変換）
`...parse ! mux.`  とすることで変換処理をスルーされ、入力のリソースが適用される。 \
音声も同様のことを行えば、ビデオ変換・音声そのままができる。

```bash
$ gst-launch-1.0 filesrc location="sample.mp4" ! progressreport ! qtdemux name=demux demux. ! queue ! aacparse ! avdec_aac ! audioresample ! audioconvert dithering=0 ! lamemp3enc bitrate=64 quality=3 ! mux. qtmux name=mux ! filesink location="test.mp4" demux. ! queue ! h264parse ! mux.
```

## 作業中
```
gst-launch-1.0 filesrc location=Arcnights.mp4 ! progressreport ! qtdemux name=demux demux. ! queue ! h264parse ! avdec_h264 ! x265enc ! h265parse ! mux. demux. ! queue ! aacparse ! mux. qtmux name=mux ! filesink location=test.mp4

gst-launch-1.0 filesrc location=Arcnights.mp4 ! progressreport ! qtdemux name=demux demux. ! queue ! h264parse ! avdec_h264 ! videoconvert ! x264enc ! queue ! mux. demux. ! queue ! aacparse ! avdec_aac ! audioconvert ! lamemp3enc bitrate=64 quality=3 ! mux. qtmux name=mux ! filesink location=test.mp4

gst-launch-1.0 filesrc location=Arcnights.mp4 ! progressreport ! qtdemux name=demux demux. ! queue ! h264parse ! avdec_h264 ! videoconvert ! x264enc bitrate=1000000 ! video/x-h264,width=1280,height=720,stream-format=byte-stream,profile=high ! h264parse demux. ! queue ! aacparse ! avdec_aac ! audioconvert ! lamemp3enc bitrate=64 quality=3 ! mux. qtmux name=mux ! filesink location=test.mp4

gst-launch-1.0 filesrc location=Arcnights.mp4 ! progressreport ! qtdemux name=demux demux. ! queue ! h264parse ! avdec_h264 ! x265enc ! h265parse ! mux. qtmux name=mux ! filesink location=test.mp4 demux. ! queue ! avdec_aac ! audioconvert ! lamemp3enc bitrate=64 quality=3 ! mux.


gst-launch-1.0 \
filesrc location=daitosho_PV.mpg  ! progressreport ! mpegpsdemux name=demuxer demuxer. ! queue ! \
mpegaudioparse ! mad ! audioresample ! audioconvert dithering=0 ! voaacenc bitrate=196000 ! mux. \
mp4mux  name=mux ! filesink location=hoge.mp4 demuxer. ! queue ! \
mpegvideoparse ! omxmpeg2videodec ! videoconvert ! \
omxh264enc target-bitrate=6000000 control-rate=variable ! video/x-h264,stream-format=byte-stream,profile=high ! \
h264parse ! mux.

gst-launch-1.0 filesrc location=test.ts ! progressreport ! tsdemux name=demuxer demuxer. ! queue ! aacparse ! avdec_aac ! audioresample ! audioconvert dithering=0 ! voaacenc bitrate=192000 ! mux. mp4mux  name=mux ! filesink location=test.mp4 demuxer. ! queue ! mpegvideoparse ! omxmpeg2videodec ! videoconvert ! omxh264enc target-bitrate=3000000 control-rate=variable ! video/x-h264,width=1280,height=720,stream-format=byte-stream,profile=high ! h264parse ! mux.
```

## 参考HP
- [gst-launch-1.0](https://gstreamer.freedesktop.org/documentation/tools/gst-launch.html?gi-language=c#)
- [GStreamerのエレメントをつないでパイプラインを組み立てるには](https://www.clear-code.com/blog/2014/7/22.html)
- [第15章 AVコーデックミドルウェア](https://manual.atmark-techno.com/armadillo-840/armadillo-840_product_manual_ja-1.3.0/ch15.html)
- [GStreamer on macOS ではじめる動画処理【video編】](https://dev.classmethod.jp/articles/gstreamer-on-macos-video/)


