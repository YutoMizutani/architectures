//
//  MVVM-Model.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 Model（モデル）
    Modelはアプリケーションのドメインモデルを指します。データ構造のほかビジネスロジックを表現する手段もモデルに含まれます

 『Android アプリ設計パターン入門』より

 */

import Foundation
import RxSwift
import RxCocoa

class MVVMModel {
    /// 残高をRxで効率的に使用するためのBehaviorRelayを含んだTupleのtypealias
    typealias UserEntity = (user: UserList, balance: BehaviorRelay<Int>)

    /// 取引に使用するユーザーを保持するArray
    private(set) var users: [UserEntity] = []

    /// Rx bindingを解除するためのDisposeBag。
    let disposeBag = DisposeBag()

    /**
     ユーザーリストを引数に，各ユーザーの情報を取得する。

     - Parameters:
        - users: ユーザーリストを元にModelで使用するEntityを作成する。
     */
    init(users: [UserList]) {
        for user in users {
            self.users.append((user, BehaviorRelay(value: 0)))
        }

        self.fetchBalance()
        self.binding()
    }
}

// MARK:- Private methods about settings
extension MVVMModel {
    /// 値の変更をバインドする。
    private func binding() {
        // 値の変更とinfrastructureの更新とのバインディングを行う。
        for user in self.users {

            // 残高の更新を通知し，保存先の更新を行う。
            user.balance.asObservable()
                .subscribe(onNext: { [weak self] _ in
                    self?.update(user)
                })
                .disposed(by: disposeBag)

        }
    }
}

// MARK:- Public methods accessed from other classes
extension MVVMModel {
    /**
     残高を取得する。

     - Parameters:
        - _users: 取得が必要なユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    public func fetch(_ _users: [UserList]=UserList.allValues) {
        self.fetchBalance(_users)
    }

    /**
     残高をリセットする。

     - Parameters:
        - _users: リセットが必要なユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    public func reset(_ _users: [UserList]=UserList.allValues) {
        self.resetBalance(_users)
    }

    /**
     送金を行う。

     - Parameters:
        - from: 送金元のユーザー
        - to: 送金先のユーザー
        - amount: 金額

     - Returns:
        Observable\<Void\>
     */
    public func transfer(from: UserList, to: UserList, amount: Int) -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            print("transfer observable")
            let from: UserEntity? = self.users.filter{ $0.user == from }.first
            let to: UserEntity? = self.users.filter{ $0.user == to }.first

            if from == nil || to == nil {
                observer.onError(ErrorTransfer.userNotFound)
                return Disposables.create()
            }

            if self.willValueAmountOverflow(to!, amount: amount) {
                observer.onError(ErrorTransfer.amountOverflow)
                return Disposables.create()
            }

            if self.willValueInsufficientFunds(from!, amount: amount) {
                observer.onError(ErrorTransfer.insufficientFunds)
                return Disposables.create()
            }

            self.credit(to!, amount: amount)
            self.debit(from!, amount: amount)

            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }
}

// MARK:- Private methods about business logics

// MARK:- Private methods about transfer
extension MVVMModel {
    /**
     取引後に残高超過に陥るかを判断する。

     - Parameters:
         - user: 対象ユーザー
         - amount: 金額

     - Returns:
        Bool (上回る場合，true)
     */
    private func willValueAmountOverflow(_ user: UserEntity, amount: Int) -> Bool {
        // 入金後の残高がIntの最大値を超過するかの判断を行う
        return user.balance.value > Int.max - amount
    }

    /**
     取引後に残高不足に陥るかを判断する。

     - Parameters:
         - user: 対象ユーザー
         - amount: 金額

     - Returns:
        Bool (下回る場合，true)
     */
    private func willValueInsufficientFunds(_ user: UserEntity, amount: Int) -> Bool {
        // 出金後の残高が0を下回るかの判断を行う
        return user.balance.value - amount < 0
    }

    /**
     入金処理を行う。

     - Parameters:
        - amount: 金額
     */
    private func credit(_ user: UserEntity, amount: Int) {
        // 金額を減算する
        user.balance.accept(user.balance.value + amount)
    }

    /**
     出金処理を行う。

     - Parameters:
        - amount: 金額
     */
    private func debit(_ user: UserEntity, amount: Int) {
        // 金額を加算する
        user.balance.accept(user.balance.value - amount)
    }
}

// MARK:- Private methods about infrastructure
extension MVVMModel {
    /**
     保存されている残高情報の取得を行う。

     - Parameters:
        - _users: 取得が必要なユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    private func fetchBalance(_ _users: [UserList]=UserList.allValues) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        var stored: Dictionary<String, Any>? {
            return userDefaults.dictionary(forKey: key)
        }

        guard let dictionary = stored else {
            self.resetBalance(_users)
            return
        }

        var failedUsers: [UserList] = []

        for _user in _users {
            guard let newValue = dictionary[_user.rawValue] as? Int else {
                failedUsers.append(_user)
                continue
            }

            self.users.filter{ $0.user == _user }.first?.balance.accept(newValue)
        }

        self.resetBalance(failedUsers)
    }

    /**
     残高をリセットする。

     - Parameters:
        - _users: リセットが必要なユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    private func resetBalance(_ _users: [UserList]=UserList.allValues) {
        // ユーザーごとに処理する。
        for user in _users {

            // 初期値を取得する。初期値が未登録の場合には0を指定する。
            let initValue = UserList.find(user.rawValue)?.initValue ?? 0

            // 一致するユーザーに対し，更新を呼ぶ。
            self.users.filter{ $0.user == user }.first?.balance.accept(initValue)

        }
    }

    /**
     保存されている残高情報の更新を行う。

     - Parameters:
        - entity: Modelで使用されるユーザー情報
     */
    private func update(_ entity: UserEntity) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        // keyを元にdictionaryを取り出す。
        var stored: Dictionary<String, Any>? {
            return userDefaults.dictionary(forKey: key)
        }

        // UserDefaultsに保存されていなかった場合は空のDictionaryを生成する。
        var dictionary: Dictionary<String, Any> = stored ?? Dictionary()

        // 引数に受け取ったユーザーの情報を反映する。
        dictionary[entity.user.rawValue] = entity.balance.value

        // 更新を保存する。
        userDefaults.set(dictionary, forKey: key)
    }
}
