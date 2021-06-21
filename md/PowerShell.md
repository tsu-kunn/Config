# PowerShell メモ

Windows PowerShell と PowerShell を使用する際のメモ。

## メモ
### スクリプトの実行を有効にする
管理者権限でPSを実行し、以下のコマンドレットを実行する必要がある。

```PowerShell
> Set-ExecutionPolicy RemoteSigned -Scope Process
```

### プロファイルの場所
`$profile` に配置される。\
自動で作成はされないので、手動で作成する必要がある。


## Web
- [PowerShell](https://github.com/PowerShell/PowerShell)
- [PowerShell ドキュメント](https://docs.microsoft.com/ja-jp/powershell/)
- [PowerShell Core入門 - 基本コマンドの使い方｜連載一覧｜](https://news.mynavi.jp/itsearch/series/devsoft/powershell_core_-.html)

