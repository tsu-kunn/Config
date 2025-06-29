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

#### 3. 動作確認
`Thonny` を起動して右下に表示されている `Local Python3` をクリックして `MicroPython(Raspberry Pi Pico` を選択する。

以下のプログラムをコード部分にコピペして、Wi-Fi設定のSSIDとパスワードを編集する。 \
▶を押下してプログラム実行してシェルにIPアドレスが出力されて、PicoのLEDが点滅したら動作確認成功。

```Python
import network
import time
from machine import Pin

# Wi-Fi設定(2.4GHzのみ対応)
ssid='your_SSID'  # 自宅のWiFiの名前
password='your_PASSWORD'  # 自宅のWiFiのパスワード

# 内蔵LEDの設定(Pico2W）
led= machine.Pin('LED', machine.Pin.OUT)

# Wi-Fiに接続
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(ssid, password)

# 接続が確立されるまで待機
while not wlan.isconnected():
    print('Connecting...')
    time.sleep(1)

print('Connected, IP address:', wlan.ifconfig()[0])

# Wi-Fi接続が成功したらLEDを点滅させる
while True:
    led.value(1)  # LEDをオンにする
    time.sleep(1)  # 1秒待機
    led.value(0)  # LEDをオフにする
    time.sleep(1)  # 1秒待機

```

#### 4. ディスプレイの動作確認
サンプルをダウンロードして回答する。

```bash
wget https://files.waveshare.com/upload/5/5a/Pico_code.7z
7z x Pico_code.7z
```

`Pico_code/Python/Pico-OLED-1.3/Pico-OLED-1.3(spi).py` を `Thonny` でロードする。 \
▶を押下してプログラムを実行し、液晶に図形や文字列が表示されたら動作確認完了。


## 自動でpythonのプログラムを実行
`Thonny` で保存を実行し、保存先を `Raspberry Pi Pico` を選択。 \
ファイル名を `main.py` で保存する。

再起動すると自動で `main.py` のプログラムが実行されれば成功。



## 参考
- https://yossy-life.com/pico-start/
- https://www.iwillgoifican.com/raspberry-pi-pico/
