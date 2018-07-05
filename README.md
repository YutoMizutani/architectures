# architectures

送金プログラムのiOSサンプル(Swift)を，様々なソフトウェアアーキテクチャで実践したものです。

他のサンプルを見てもAPIに認証が必要であったり，画面がいくつもあったりして，アーキテクチャの勉強をしているのか，それとも他の複雑なプログラムの勉強をしているのか分からなくなります。

そこで，簡単な1画面のプログラムを，オフラインで動作するように作成しました。
比較がしやすいよう，git branchで切り換えるのではなく，UISplitViewControllerを用いて1画面で確認できるようにしました。

## 動作概要

WatanabeさんからTakahashiさんへ，一方通行にお金を送金するプログラムです。


- RESETボタンを押すと，Watanabeさんは0に，Takahashiさんは1000に初期化されます。

- TRANSFERボタンを押すと，Watanabeさんは-100，Takahashiさんは+100されます。

- Watanabeさんが0の場合にTRANSFERボタンを押すとErrorのアラートが表示され，キャンセルされます。

![screenshot](https://github.com/YutoMizutani/architectures/blob/master/src/pic/screenshot.png)

## 各アーキテクチャについて

## PDS

#### 概要

Presentation Domain Separationの略。プレゼンテーションロジックとドメインロジックが分離されることで，

[プレゼンテーションとドメインの分離 - Martin Fowler's Bliki (ja)](http://bliki-ja.github.io/PresentationDomainSeparation/)
> - プレゼンテーションロジックとドメインロジックが分かれていると、理解しやすい
同じ基本プログラムを、重複コードなしに、複数のプレゼンテーションに対応させることができる
> - ユーザーインターフェイスはテストがしにくいため、それを分離することにより、テスト可能なロジック部分に集中できる
> - スクリプト用のAPIやサービスとして外部化するためのAPIを楽に追加できる（選択可能なプレゼンテーション部分で見かける）
> - プレゼンテーション部分のコードは、ドメイン部分のコードと違ったスキルと知識が必要

のメリットを享受することができる。

#### (本リポジトリにおける) ディレクトリ構成

- Presentation (inherited UIViewController)
- Domain

#### 依存関係

#### 参考

- [プレゼンテーションとドメインの分離 - Martin Fowler's Bliki (ja)](http://bliki-ja.github.io/PresentationDomainSeparation/)
- [MVCとかMVVMの前の自分まとめ - メモを揉め](http://memowomome.hatenablog.com/entry/2014/04/13/102736)
- [MOVEは望まれなかった子 - the sea of fertility](http://ugaya40.hateblo.jp/entry/dis-move)

#### 議論

## MVC

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- Model
- View
- Controller (inherits UIViewController)

#### 依存関係

#### 参考

#### 議論

## MVP

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- Model
- View (inherits UIViewController)
- Presenter

#### 依存関係

#### 参考

#### 議論

## MVVM

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- Model
- View
- ViewModel (inherits UIViewController)

#### 依存関係

- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

#### 議論

## DDD

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- UserInterface (inherits UIViewController)
- Application
- Domain
- Entity
- Infrastructure

#### 依存関係

#### 参考

#### 議論

## ReSwift

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)
- Reducer
- State
- Actions

#### 依存関係

- [ReSwift](https://github.com/ReSwift/ReSwift)

#### 参考

#### 議論

## ReactorKit

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)
- Reactor

#### 依存関係

- [ReactorKit](https://github.com/ReactorKit/ReactorKit)
- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

#### 議論

## VIPER

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)
- Interactor
- Presenter
- Entity
- Router
- Protocols

#### 依存関係

#### 参考

- [iOS Project Architecture : Using VIPER [和訳]](https://qiita.com/YKEI_mrn/items/67735d8ebc9a83fffd29)
- [Juanpe/Swift-VIPER-Module](https://github.com/Juanpe/Swift-VIPER-Module)

#### 議論

## Clean Architecture

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- Application/
	- Wireframe
	- Builder
- Data/
	- Repository
	- DataStore
	- Entity
- Domain/
	- UseCase
	- Translator
	- Model
- Presentation/
	- Presenter
	- UI/
		- View
		- ViewController (inherits UIViewController)

#### 依存関係

- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

#### 議論

## RxFeedback

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- View
- ViewController (inherits UIViewController)
- State
- Event

#### 依存関係

- [RxFeedback](https://github.com/NoTests/RxFeedback.swift)
- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

#### 議論

## Realistic ViewController

#### 概要

この設計で実装する最低限の機能を実装したViewController。保存処理も含めない。
「最低限動く」このVCにユーザー管理の分割や保存処理を追加したものが各アーキテクチャで構成される。

保存処理を実装していない為，値の保持や他のViewとの連携は行われない。

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)

#### 依存関係

- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

#### 議論

## 終わりに

本リポジトリは，ソフトウェア設計における情報を統一しようと試みるものであり，設計そのもの及び歴史に関する誤謬を含んだものであることを断っておきます。本記事及びコードが正確であることを保証するものではありません。本リポジトリは全てのアーキテクチャを網羅するものではなく，どれかを比較したり，優劣をつける意図はありません。