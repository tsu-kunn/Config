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
[Raspberry Pi公式ドキュメントのMicroPythonサイト](https://www.raspberrypi.com/documentation/microcontrollers/micropython.html) の `Download the correct MicroPython UF2 file for your board:` から `Pico 2 W` を選択してファームウェアをダウンロードする。

```bash
curl -O https://downloads.raspberrypi.com/micropython/mp_firmware_unofficial_latest.uf2
```

##### MicroPython公式のファームウェア
[MicroPython公式のダウンロードページ](https://micropython.org/download/RPI_PICO2_W/) からもダウンロード可能。 \
ラズパイ公式のファームウェアで問題がある場合に試すとよいかも。

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

##### ピクセル、線、塗りつぶしなどの描画
[framebuf](https://micropython-docs-ja.readthedocs.io/ja/latest/library/framebuf.html) ライブラリを使用してこれらの描画を行う。 \
画像表示もフレームバッファを使って描画する。

```python
# OLED_1inch3クラスはPico-OLED-1.3(spi).pyと同じなので省略

if __name__=='__main__':

    OLED = OLED_1inch3()

    OLED.fill(0x0000) 
    keyA = Pin(15, Pin.IN, Pin.PULL_UP)
    keyB = Pin(17, Pin.IN, Pin.PULL_UP)

    # BMP画像の読み込み関数（1bit BMP専用）
    def load_bmp(filename):
        with open(filename, 'rb') as f:
            if f.read(2) != b'BM':
                raise ValueError("Not a BMP file")

            f.seek(10)
            offset = ustruct.unpack('<I', f.read(4))[0]
            print(f'offset={offset}')
            f.seek(18)
            width = ustruct.unpack('<I', f.read(4))[0]
            height = ustruct.unpack('<I', f.read(4))[0]
            print(f'width={width}, height={height}')

            f.seek(28)
            bpp = ustruct.unpack('<H', f.read(2))[0]
            if bpp != 1:
                raise ValueError("Only 1-bit BMP supported")

            f.seek(offset)
            row_size = ((width + 31) // 32) * 4  # 1bit BMPの1行のバイト数（4バイト境界）
            print(f'row_size={row_size}')
            buf = bytearray(width * height // 8)

            for y in range(height):
                row = f.read(row_size)
                for x in range(width // 8):
                    buf[(height - 1 - y) * (width // 8) + x] = row[x]

            return framebuf.FrameBuffer(buf, width, height, framebuf.MONO_HLSB)

    # QRコード読み込み
    bmp = load_bmp("QR.bmp")

    showQR = False

    while (1):
        #if keyA.value() == 0:
        #    print("A")

        if (keyB.value() == 0):
            showQR ^= 1
            print("B")

        OLED.fill(0x0000)

        if showQR:
            OLED.text("Go to", 0, 10, OLED.white)
            OLED.text("HomePage", 0, 20, OLED.white)
            OLED.blit(bmp, 64, 0)
        else:
            OLED.text("X@tsu_kunn", 1, 10, OLED.white)
            OLED.text("Mixi2@tsu_kunn", 1, 27, OLED.white)
            OLED.text("Key1 to View QR", 1, 44, OLED.white)

        OLED.show()

    time.sleep(1)
    OLED.fill(0xFFFF)
```

## 自動でpythonのプログラムを実行
`Thonny` で保存を実行し、保存先を `Raspberry Pi Pico` を選択。 \
ファイル名を `main.py` で保存する。

再起動すると自動で `main.py` のプログラムが実行されれば成功。

## ルートにファイルを追加する方法
1. Thonnyでファイルビューを表示
    - メニューから [表示] → [ファイル] を選択
    - 左側に「このコンピュータ」、右側に「Raspberry Pi Pico」が表示される
1. ファイルをアップロード
    - 左側でアップロードしたいファイル（例：QR.bmp）を右クリック
    - 「/をアップロード」 を選択


## 参考
- [MicroPython公式](https://micropython.org/)
- [MicroPythonライブラリ](https://micropython-docs-ja.readthedocs.io/ja/latest/library/index.html)
- [【超入門】Raspberry Pi Picoを使った電子工作の始め方を徹底解説！](https://yossy-life.com/pico-start/)
- [Raspberry Pi Pico/PicoW、2Wの完全ガイド](https://www.iwillgoifican.com/raspberry-pi-pico/)
- [リラックス解除](https://micropython.org/download/RPI_PICO2/RPI_PICO2-latest.uf2)
- [Raspberry Pi Pico Wを使ってみよう](https://iwoneko.blogspot.com/2025/06/raspberry-pi-pico-w.html?m=1)
