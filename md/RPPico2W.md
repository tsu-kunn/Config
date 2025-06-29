# Raspberry Pi Pico 2Wのメモ

## 購入したもの
- [Raspberry Pi Pico 2 WH](https://www.switch-science.com/products/10258?variant=44459979407558)
- [Raspberry Pi Pico用 1.3インチOLEDディスプレイモジュール](https://www.switch-science.com/products/7549?variant=42382170915014)
  - [資料](https://www.waveshare.com/wiki/Pico-OLED-1.3)

## 開発環境
- [Raspberry Pi 4 Model B / 4GB](https://www.switch-science.com/products/5680?_pos=3&_sid=077434481&_ss=r)
- [Thonny](https://thonny.org/)
  - ラズパイOSに標準でインストールされているものを使用

## 初期設定と動作確認
### ファームウェアアップデート
#### 1. ファームウェアのダウンロード
[MicroPython公式サイト](https://www.raspberrypi.com/documentation/microcontrollers/micropython.html) の `Download the correct MicroPython UF2 file for your board:` から `Pico 2 W` を選択してファームウェアをダウンロードする。

```bash
curl -O https://downloads.raspberrypi.com/micropython/mp_firmware_unofficial_latest.uf2
```

#### 2. ファームウェアの更新
`BOOTSEL` ボタンを押下したままでUSBケーブルを接続するとUSBストレージとして認識されるので、
1でダウンロードした `uf2ファイル` をここにコピーする。

コピーすると自動的にファームウェアが更新されて、`Raspberry Pi Pico 2W` が自動的に再起動されます。 \
(これでMicroPythonが使えるようになる)



## 参考
- https://yossy-life.com/pico-start/
- https://www.iwillgoifican.com/raspberry-pi-pico/
