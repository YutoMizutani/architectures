//
//  RF-ViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback

public typealias RFUser = (user: UserList, balance: Int)
public typealias RFTransfer = (to: RFUser, from: RFUser)

class RFViewController: UIViewController {
    private typealias State = RFState
    private typealias Event = RFEvent

    // ViewとModelを保持する。
    var subview: RFView!
    private var state: State!
    private let users: (to: UserList, from: UserList) = (.takahashi, .watanabe)

    /// Rx bindingを解除するためのDisposeBag。
    let disposeBag = DisposeBag()
}

// MARK:- Override methods
extension RFViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureFeedback()
        layoutView()
        binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.state = State.initialState
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutView()

        self.view.layoutIfNeeded()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        layoutView()
    }
}

// MARK:- Private methods about settings
extension RFViewController {
    /// Viewの構成を行う。
    private func configureView() {
        // Viewを作成する。
        self.subview = RFView()

        // Viewに表示されるラベルの名前を設定する。
        self.subview.toView.nameLabel.text = "\(UserList.takahashi.rawValue): "
        self.subview.fromView.nameLabel.text = "\(UserList.watanabe.rawValue): "

        // Viewに追加する。
        self.view.addSubview(self.subview)
    }

    /// Modelの構成を行う。
    private func configureFeedback() {
        let bindUI: (ObservableSchedulerContext<State>) -> Observable<Event> = RxFeedback.bind(self) { (me, state) in
            // 状態変化に伴って変更されうるUIを定義する。
            let subscriptions = [
                state
                    .filter { $0 == State.ready }
                    .subscribe(onNext: { [weak self] _ in
                        Event.fetch()
                    }),

                state
                    .filter { $0 == State.balanceDidChange }
                    .subscribe(onNext: { [weak self] balance in
                        self?.subview.toView.valueLabel.text = "\(balance.to)"
                        self?.subview.fromView.valueLabel.text = "\(balance.from)"
                    }),

                state
                    .filter { $0 == State.balanceWillChange }
                    .subscribe(onNext: { transfer in
                        Event.update(transfer)
                    }),


//                /// If no contents, write "Observable<Any>.empty().subscribe(),".
//                // Observable<Any>.empty().subscribe(),
//                state
//                    .filter { $0 == State.ending }
//                    .subscribe(onNext: { _ in
//                        print("\nEnd of the session")
//                        self.exit()
//                    }),
//                state
//                    // 最初の .readyが2回呼ばれるため，previousStateでfilter
//                    .filter { $0 != me.previousState }
//                    .map { ($0, $0.stateString) }
//                    .replay(1).refCount() // https://qiita.com/kazu0620/items/bde4a65e82a10bd33f88
//                    .subscribe(onNext: { state, str in
//                        me.previousState = state
//                        print(str)
//
//                        // Start command
//                        DispatchQueue.global().async {
//                            print("Command?")
//                            print("> ", terminator: "")
//                            let text = readLine() ?? ""
//                            print("> read: \(text)")
//                            me.previousState = nil
//                            me.commandText.value = text
//                        }
//
//                    }, onCompleted: {
//                        // Stateは保持されるのでonCompletedが発火しない
//                    }),
                ]

            // ObservableからEventを流すユーザーアクションを指定する。
            let events = [
                me.subview.transferButton.rx.tap
                    .asObservable()
                    .map { Event.transfer(to: .takahashi, from: .watanabe, amount: Assets.amount) },
                ]
            return Bindings(subscriptions: subscriptions, events: events)
        }

        Observable.system(
            initialState: State.initialState,
            reduce: { [unowned self] state, event in
                // in: event, out: state
                switch event {
                case .fetch:
                    let balance = self.fetch()
                    return State.balanceWillChange(balance)
                case .update(let t):
                    self.update(t)
                    return State.balanceDidChange(t)
                case .reset:
                    let balance = self.resetted
                    return State.balanceWillChange(balance)
                case .transfer(let to, let from, let amount):
                    let balance = self.resetted

                    return State.balanceWillChange(balance)
                }
                return state
            },
            scheduler: MainScheduler.instance,
            scheduledFeedback:
            bindUI
            )
            .subscribe()
            .disposed(by: disposeBag)
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }

    /// View要素とBusiness logicのバインディングを行う。
    private func binding() {
//        // Takahashiさんの残高をラベルにバインドする。
//        self.model?.users.filter{ $0.user == .takahashi }.first?.balance
//            .map{ "\($0)" }
//            .asDriver(onErrorJustReturn: "Rx binding error!")
//            .drive(self.subview.toView.valueLabel.rx.text)
//            .disposed(by: self.disposeBag)
//
//        // Watanabeさんの残高をラベルにバインドする。
//        self.model?.users.filter{ $0.user == .watanabe }.first?.balance
//            .map{ "\($0)" }
//            .asDriver(onErrorJustReturn: "Rx binding error!")
//            .drive(self.subview.fromView.valueLabel.rx.text)
//            .disposed(by: self.disposeBag)
//
//        // 送金処理をボタンにバインドする。
//        // この時，onErrorが発生するとRxの購読が解除されてしまうため，onError発生時に再帰的に再購読を行う。
//        func bindingErrorable() {
//            self.subview.transferButton.rx.tap
//                .asObservable()
//                // WatanabeさんからTakahashiさんに送金を行う。
//                .flatMap{ self.model.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount) }
//                .subscribe(onError: { [weak self] e in
//
//                    // アラートを表示する。
//                    self?.showAlert(error: e)
//
//                    // 再帰的に再購読を行う。
//                    bindingErrorable()
//
//                })
//                .disposed(by: self.disposeBag)
//        }
//        bindingErrorable()
//
//        // 残高のリセット処理をボタンにバインドする。
//        self.subview.resetButton.rx.tap
//            .asObservable()
//            .subscribe(onNext: { [weak self] _ in
//
//                // 残高のリセットを行う。
//                self?.model.reset()
//
//            })
//            .disposed(by: self.disposeBag)
    }
}

extension RFViewController: ErrorShowable {
    private var resetted: RFTransfer {
        return (
            to: (user: self.users.to, balance: self.users.to.initValue),
            from: (user: self.users.from, balance: self.users.from.initValue)
        )
    }

    private func fetch() -> RFTransfer {
        do {
            let transfer = try self.fetch(to: self.users.to, from: self.users.from)
            return transfer
        }catch let e {
            self.showAlert(error: e)
            return self.resetted
        }
    }

    private func transfer(to: UserList, from: UserList, amount: Int) {

    }
}

extension RFViewController {
    /// UserDefaultsから更新を取得する。
    private func fetch(to: UserList, from: UserList) throws -> RFTransfer {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        guard let dictionary = userDefaults.dictionary(forKey: key) else {
            throw ErrorTransfer.noContent
        }

        guard let toAny = dictionary[to.rawValue] else {
            throw ErrorTransfer.userNotFound
        }
        guard let toBalance: Int = toAny as? Int else {
            throw ErrorTransfer.storedTypeInvalid
        }

        guard let fromAny = dictionary[from.rawValue] else {
            throw ErrorTransfer.userNotFound
        }
        guard let fromBalance: Int = fromAny as? Int else {
            throw ErrorTransfer.storedTypeInvalid
        }

        return (to: (user: to, balance: toBalance), from: (user: from, balance: fromBalance))
    }

    /// UserDefaultsへ更新を実行する。
    private func update(_ transfer: RFTransfer) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        var dictionary = userDefaults.dictionary(forKey: key) ?? Dictionary<String, Any>()
        dictionary[transfer.to.user.rawValue] = transfer.to.balance
        dictionary[transfer.from.user.rawValue] = transfer.from.balance

        // 保存する。
        userDefaults.set(dictionary, forKey: key)
    }
}
