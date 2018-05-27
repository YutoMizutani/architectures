# architectures

送金プログラムのiOSサンプル(Swift)を，様々なソフトウェアアーキテクチャで実践したものです。

他のサンプルを見てもAPIに認証が必要であったり，画面がいくつもあったりして，アーキテクチャの勉強をしているのか，それとも他の複雑なプログラムの勉強をしているのか分からなくなります。

そこで，簡単な1画面のプログラムを，オフラインで動作するように作成しました。
比較がしやすいよう，git branchで切り換えるのではなく，UISplitViewControllerを用いて1画面で確認できるようにしました。

## 送金プログラム

WatanabeさんからTakahashiさんへ，一方通行にお金を送金するプログラムです。


RESETボタンを押すと，Watanabeさんは0に，Takahashiさんは1000に初期化されます。

TRANSFERボタンを押すと，Watanabeさんは-100，Takahashiさんは+100されます。

Watanabeさんが0の場合にTRANSFERボタンを押すとErrorのアラートが表示され，キャンセルされます。

![screenshot](https://github.com/YutoMizutani/architectures/blob/master/src/pic/screenshot.png)