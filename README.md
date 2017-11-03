## 概要

cwalert-diskのマルチマウントポイント対応版です

「ディスクサイズアラートをチャットワークにあげたい」な要求により作成した個人的最低限の実装 by mruby

## アンニュイな点

* centos6系（Amazon Linux含む）のみ確認
* docker、、、なにそれ、うまいの？（クロスコンパイル系は一旦コメントアウト）
* そもそもディクスサイズの確認方法が力技&絶対にNGな環境がある（osxとか）

## install

``` bash
git clone https://github.com/pacojp/cwalert-disk2.git
cd cwalert-disk2/
rake
./mruby/bin/cwalert-disk2 YOUR_CONFIG_FILE_PATH
```

## config file format

``` json
{
  "verbose": true,
  "hostname": "YOUR_HOST_NAME",
  "mount_points": [
    {"mount_point": "/", "warning": 70, "critical": 80},
    {"mount_point": "/home", "warning": 60, "critical": 90}
  ],
  "warning-hours": [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
  "cw": {
    "room-id":  "CW_ROOM_ID",
    "token":    "CW_TOKEN",
    "users-to": ["CW_USER_ID_A_TO_ALERT", "CW_USER_ID_B_TO_ALERT"]
  }
}
```
optionals

* verbose
* hostname
* warning-hours
* users-to

## usage

誰かが使うとは思っていないけど、、一応自身の環境できちんと動作確認すること（cron設定のレベルまで）。レポートオプションも付けてないので（プログラム自体はキチンと動いていますよ報告）、事前に動作確認をきちんと取らないとひどい目に合いますよ。

### warning-hours

ワーニングごときで夜起きたくねぇよ設定

## 言い訳

もっと機能を増やそうと思えば増やせますが、本プログラムはあくまで補助++の位置付けということで単機能にしてます。

サーバのステータス管理は（個人的には） influxDB + grafana + オレオレスクリプト がオススメです。

まっとうに予算がついているならばmackerel等使うべきです（CWにも簡単にアラートあげられるよ）。
