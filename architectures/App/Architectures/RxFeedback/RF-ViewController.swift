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

/// ユーザー情報。mapできた方が嬉しいためstructで定義。
public struct RFUser {
    let user: UserList
    let balance: Int
    init(user: UserList, balance: Int) {
        self.user = user
        self.balance = balance
    }
}
extension RFUser {
    public func map(_ transform: @escaping (RFUser) -> RFUser) -> RFUser {
        return transform(self)
    }
}

/// 取引情報。Stateで引き渡しをするのみなのでtypealiasで記述する。
public typealias RFTransfer = (to: RFUser, from: RFUser)


class RFViewController: UIViewController {
    private typealias State = RFState
    private typealias Event = RFEvent

    // ViewとModelを保持する。
    var subview: RFView!
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
        self.subview.toView.nameLabel.text = "\(self.users.to.rawValue): "
        self.subview.fromView.nameLabel.text = "\(self.users.from.rawValue): "

        // Viewに追加する。
        self.view.addSubview(self.subview)
    }

    /// Feedbackの構成を行う。
    private func configureFeedback() {
        let bindUI: (ObservableSchedulerContext<State>) -> Observable<Event> = RxFeedback.bind(self) { (me, state) in
            // 状態変化に伴って変更されうるUIを定義する。
            let subscriptions = [
                // 残高情報の変更に合わせ，UIを更新する。
                state
                    .filter { $0 == State.balanceDidChange(nil) }
                    .subscribe(onNext: { [weak self] balance in
                        self?.subview.toView.valueLabel.text = "\(balance.transfer!.to.balance)"
                        self?.subview.fromView.valueLabel.text = "\(balance.transfer!.from.balance)"
                    }),
                ]

            // ObservableからEventを流すユーザーアクションを指定する。
            let events = [
                // Transferボタンのアクションを登録する。
                me.subview.transferButton.rx.tap
                    .asObservable()
                    .map { [unowned self] _ in
                        Event.transfer(to: self.users.to, from: self.users.from, amount: Assets.amount)
                    },

                // Resetボタンのアクションを登録する。
                me.subview.resetButton.rx.tap
                    .asObservable()
                    .map { Event.reset },

                // 開始時に更新を行う。
                state
                    .filter { $0 == State.begin }
                    .map { _ in Event.fetch },

                // 残高に変更があった場合にアップデートを呼ぶ。
                state
                    .filter { $0 == State.balanceWillChange(nil) }
                    .map { Event.update($0.transfer!) },

                // 残高の更新終了時に終了イベントを発行する。
                state
                    .filter { $0 == State.balanceDidChange(nil) }
                    .map { _ in Event.stabilize },
                ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        Observable.system(
            initialState: State.initialState,
            reduce: { [unowned self] state, event in
                // in: event, out: state

                // Eventごとに処理を分岐させる。
                switch event {
                case .stabilize:
                    return State.ready

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
                    let balance = self.transfer(to: to, from: from, amount: amount)
                    return State.balanceWillChange(balance)
                }
            },
            scheduler: MainScheduler.instance,
            scheduledFeedback: bindUI
            )
            .subscribe()
            .disposed(by: disposeBag)
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }
}

extension RFViewController: ErrorShowable {
    /**
     初期化を行う。

     - Returns:
        取引情報
     */
    private var resetted: RFTransfer {
        return (
            to: RFUser(user: self.users.to, balance: self.users.to.initValue),
            from: RFUser(user: self.users.from, balance: self.users.from.initValue)
        )
    }

    /**
     更新を行う。

     - Returns:
        取引情報
     */
    private func fetch() -> RFTransfer {
        do {

            let transfer = try self.fetch(to: self.users.to, from: self.users.from)
            return transfer

        }catch let e {

            self.showAlert(error: e)
            return self.resetted

        }
    }

    /**
     更新を行う。

     - Parameters:
         - to: 取引先のユーザー
         - from: 取引元のユーザー
         - amount: 金額

     - Returns:
        取引情報
     */
    private func transfer(to: UserList, from: UserList, amount: Int) -> RFTransfer {
        // 口座情報の取得を行う。
        var transfer: RFTransfer!
        do {

            transfer = try self.fetch(to: to, from: from)

        }catch let e {

            self.showAlert(error: e)
            return self.resetted

        }

        // 口座情報の取得成功後に取引を行う。
        do {

            let to = try self.credit(transfer.to, amount: amount)
            let from = try self.debit(transfer.from, amount: amount)
            return (to: to, from: from)

        }catch let e {

            self.showAlert(error: e)
            return transfer

        }
    }
}

extension RFViewController {
    /**
     入金処理を行う。

     - Parameters:
         - user: 対象ユーザー
         - amount: 金額

     - throws:
        取引後に残高超過に陥る場合
     - Returns:
        口座情報
     */
    private func credit(_ user: RFUser, amount: Int) throws -> RFUser {
        // 入金後の残高がIntの最大値を超過するかの判断を行う
        if user.balance > Int.max - amount {
            throw ErrorTransfer.amountOverflow
        }
        // 金額を加算する。
        return user.map{ RFUser(user: $0.user, balance: $0.balance + amount) }
    }

    /**
     出金処理を行う。

     - Parameters:
         - user: 対象ユーザー
         - amount: 金額

     - throws:
        取引後に残高不足に陥る場合
     - Returns:
        口座情報
     */
    private func debit(_ user: RFUser, amount: Int) throws -> RFUser {
        // 出金後の残高が0を下回るかの判断を行う
        if user.balance - amount < 0 {
            throw ErrorTransfer.insufficientFunds
        }
        // 金額を減算する。
        return user.map{ RFUser(user: $0.user, balance: $0.balance - amount) }
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

        return (to: RFUser(user: to, balance: toBalance), from: RFUser(user: from, balance: fromBalance))
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
