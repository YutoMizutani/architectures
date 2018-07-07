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

#### 依存ライブラリ

(なし)

#### 参考

- [PresentationDomainSeparation - Martin Fowler](https://martinfowler.com/bliki/PresentationDomainSeparation.html)
- [プレゼンテーションとドメインの分離 - Martin Fowler's Bliki (ja)](http://bliki-ja.github.io/PresentationDomainSeparation/)
- [MVCとかMVVMの前の自分まとめ - メモを揉め](http://memowomome.hatenablog.com/entry/2014/04/13/102736)
- [MOVEは望まれなかった子 - the sea of fertility](http://ugaya40.hateblo.jp/entry/dis-move)

#### 議論

(なし)

## MVC

#### 概要

Viewはアプリケーションの表示に関わるオブジェクトを定義し，ControllerはViewにおけるアクションの定義および遷移に関わる処理を，Modelにはデータおよびその処理を担う。
この時，ViewとModelはControllerを必ず経由し，ModelにはUIに関わるロジックは含まれない。
プレゼンテーションロジックとドメインロジックの分離に適した設計。

![model_view_controller_2x.png](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Art/model_view_controller_2x.png)
[https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Art/model_view_controller_2x.png](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Art/model_view_controller_2x.png)

ちなみに，

[MVC - Apple Developer](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)
> MVC is central to a good design for a Cocoa application. The benefits of adopting this pattern are numerous. Many objects in these applications tend to be more reusable, and their interfaces tend to be better defined. Applications having an MVC design are also more easily extensible than other applications. Moreover, many Cocoa technologies and architectures are based on MVC and require that your custom objects play one of the MVC roles.

と，Apple側の多くの設計はMVCに基づいていることが明記されている。

MVCの理解にはしばしば誤解があると言われる([議論を参照](https://github.com/YutoMizutani/architectures#%E8%AD%B0%E8%AB%96-1))。

#### (本リポジトリにおける) ディレクトリ構成

- Model
- View
- Controller (inherits UIViewController)

#### 依存ライブラリ

(なし)

#### 参考

- [MVC - Apple Developer](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)
- [iOS開発でのMVCとは - スタック・オーバーフロー](https://ja.stackoverflow.com/questions/25253/ios%E9%96%8B%E7%99%BA%E3%81%A7%E3%81%AEmvc%E3%81%A8%E3%81%AF)
- [これが最強のMVC(iOS) - Qiita](https://qiita.com/koitaro/items/b3a924245fd72f22871a)
- [iOS Architecture Patterns; Demystifying MVC, MVP, MVVM and VIPER – Medium](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)
- [MOVEは望まれなかった子 - the sea of fertility](http://ugaya40.hateblo.jp/entry/dis-move)

#### 議論

- [やはりお前らのMVCは間違っている - SlideShare](https://www.slideshare.net/MugeSo/mvc-14469802)
- [Ruby on Railsの「えせMVC」の弊害 - Life is beautiful](http://satoshi.blogs.com/life/2009/10/rails_mvc.html)
- [やはりおまえらの MVC は間違えている in バックボーンジェーエス - 猫型の蓄音機は 1 分間に 45 回にゃあと鳴く](https://nekogata.hatenablog.com/entry/2013/11/11/075234)

## MVP

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- Model
- View (inherits UIViewController)
- Presenter

#### 依存ライブラリ

(なし)

#### 参考

- [iOS Architecture Patterns; Demystifying MVC, MVP, MVVM and VIPER – Medium](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)

#### 議論

- [AndroidではMVCよりMVPの方がいいかもしれない - Konifar's WIP](http://konifar.hatenablog.com/entry/2015/04/17/010606)

## MVVM

#### 概要

(なし)

#### (本リポジトリにおける) ディレクトリ構成

- Model
- View
- ViewModel (inherits UIViewController)

#### 依存ライブラリ

- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

- [Model-View-View Model を利用した汎用性のあるクラス ライブラリの使用 - Microsoft Docs](https://docs.microsoft.com/ja-jp/dotnet/standard/cross-platform/using-portable-class-library-with-model-view-view-model)

#### 議論

(なし)

## DDD

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- UserInterface (inherits UIViewController)
- Application
- Domain
- Entity
- Infrastructure

#### 依存ライブラリ

(なし)

#### 参考

(なし)

#### 議論

(なし)

## ReSwift

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)
- Reducer
- State
- Actions

#### 依存ライブラリ

- [ReSwift](https://github.com/ReSwift/ReSwift)

#### 参考

(なし)

#### 議論

(なし)

## ReactorKit

#### 概要

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)
- Reactor

#### 依存ライブラリ

- [ReactorKit](https://github.com/ReactorKit/ReactorKit)
- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

(なし)

#### 議論

(なし)

## VIPER

#### 概要

![viper_architecture-2000x720.jpg](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/04/viper_architecture-2000x720.jpg)
[https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/04/viper_architecture-2000x720.jpg](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2016/04/viper_architecture-2000x720.jpg)

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)
- Interactor
- Presenter
- Entity
- Router
- Protocols

#### 依存ライブラリ

(なし)

#### テンプレート生成ツール

- [Juanpe/Swift-VIPER-Module - GitHub](https://github.com/Juanpe/Swift-VIPER-Module)

#### 参考

- [iOS Project Architecture : Using VIPER [和訳]](https://qiita.com/YKEI_mrn/items/67735d8ebc9a83fffd29)
- [iOS Project Architecture: Using VIPER - Cheesecake Labs](https://cheesecakelabs.com/blog/ios-project-architecture-using-viper/)
- [Juanpe/Swift-VIPER-Module](https://github.com/Juanpe/Swift-VIPER-Module)

#### 議論

(なし)

## Clean Architecture

#### 概要

依存関係逆転の原則(Dependency Inversion Principle)によって

![CleanArchitecture-8d1fe066e8f7fa9c7d8e84c1a6b0e2b74b2c670ff8052828f4a7e73fcbbc698c.jpg](https://8thlight.com/blog/assets/posts/2012-08-13-the-clean-architecture/CleanArchitecture-8d1fe066e8f7fa9c7d8e84c1a6b0e2b74b2c670ff8052828f4a7e73fcbbc698c.jpg)
[https://8thlight.com/blog/assets/posts/2012-08-13-the-clean-architecture/CleanArchitecture-8d1fe066e8f7fa9c7d8e84c1a6b0e2b74b2c670ff8052828f4a7e73fcbbc698c.jpg](https://8thlight.com/blog/assets/posts/2012-08-13-the-clean-architecture/CleanArchitecture-8d1fe066e8f7fa9c7d8e84c1a6b0e2b74b2c670ff8052828f4a7e73fcbbc698c.jpg)

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

#### 依存ライブラリ

- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### テンプレート生成ツール

- [bannzai/Kuri - GitHub](https://github.com/bannzai/Kuri)

#### 参考

- [The Clean Architecture | 8th Light - 8th Light Blog](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html)
- [クリーンアーキテクチャ(The Clean Architecture翻訳) - blog.tai2.net](https://blog.tai2.net/the_clean_architecture.html)
- [まだiOS Clean Architecture で消耗してるの？ 爆速開発ツールを作ったのでご紹介 - Qiita](https://qiita.com/bannzai/items/6e8add18b15af235a19f)

#### 議論

(なし)

## RxFeedback

#### 概要

![RxFeedback.png](https://github.com/kzaher/rxswiftcontent/raw/master/RxFeedback.png)
[https://github.com/kzaher/rxswiftcontent/raw/master/RxFeedback.png](https://github.com/kzaher/rxswiftcontent/raw/master/RxFeedback.png)

#### (本リポジトリにおける) ディレクトリ構成

- View
- ViewController (inherits UIViewController)
- State
- Event

#### 依存ライブラリ

- [RxFeedback](https://github.com/NoTests/RxFeedback.swift)
- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

- [RxFeedback](https://github.com/NoTests/RxFeedback.swift)
- [Modern RxSwift Architectures - Realm Academy](https://academy.realm.io/posts/try-swift-nyc-2017-krunoslav-zaher-modern-rxswift-architectures/)

#### 議論

(なし)

## Realistic ViewController

#### 概要

この設計で実装する最低限の機能を実装したViewController。保存処理も含めない。
「最低限動く」このVCにユーザー管理の分割や保存処理を追加したものが各アーキテクチャで構成される。

保存処理を実装していない為，値の保持や他のViewとの連携は行われない。

#### (本リポジトリにおける) ディレクトリ構成

- ViewController (inherits UIViewController)

#### 依存ライブラリ

- [RxSwift](https://github.com/ReactiveX/RxSwift)

#### 参考

(なし)

#### 議論

(なし)

## 他，まとめ，歴史，比較記事

#### まとめ

- [開発者が知っておくべき、6つのUIアーキテクチャ・パターン - ＠IT](http://www.atmarkit.co.jp/fdotnet/chushin/greatblogentry_10/greatblogentry_10_01.html)
- [Androidアーキテクチャことはじめ ― 選定する意味と、MVP、Clean Architecture、MVVM、Fluxの特徴を理解する - エン転職](https://employment.en-japan.com/engineerhub/entry/2018/01/17/110000)

#### 歴史

- [雑把の UI アーキテクチャー史(MVCからMVVMへ) | プログラマーズ雑記帳](http://yohshiy.blog.fc2.com/blog-entry-215.html)
- [私がMVCフレームワークをもはや使わない理由 - InfoQ](https://www.infoq.com/jp/articles/no-more-mvc-frameworks)

#### 比較

- [Webアプリケーション開発者から見た、MVCとMVP、そしてMVVMの違い - Qiita](https://qiita.com/shinkuFencer/items/f2651073fb71416b6cd7)

## 終わりに

本リポジトリは，ソフトウェア設計における情報を統一しようと試みるものであり，設計そのもの及び歴史に関する誤謬を含んだものであることを断っておきます。本記事及びコードが正確であることを保証するものではありません。そもそも設計方針であって，単体で1アーキテクチャとして成立するとは言い難いものもあります。本リポジトリは全てのアーキテクチャを網羅するものではなく，それぞれを比較し，優劣をつけるような意図はありません。