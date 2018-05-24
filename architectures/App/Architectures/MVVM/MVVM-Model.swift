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
    typealias UserEntity = (user: UserList, balance: BehaviorRelay<Int>)
    private(set) var users: [UserEntity] = []

    let disposeBag = DisposeBag()

    init(users: [UserList]) {
        for user in users {
            self.users.append((user, BehaviorRelay(value: 0)))
        }

        self.fetchBalance()
        self.binding()
    }
}

extension MVVMModel {
    private func binding() {
        for user in self.users {
            user.balance.asObservable()
                .subscribe(onNext: { [unowned self] _ in
                    self.update(user)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension MVVMModel {
    public func fetch(_ _users: [UserList]=UserList.allValues) {
        self.fetchBalance(_users)
    }

    public func reset(_ _users: [UserList]=UserList.allValues) {
        self.resetBalance(_users)
    }

    public func transfer(from: UserList, to: UserList, amount: Int) -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            let from: UserEntity? = self.users.filter{ $0.user == from }.first
            let to: UserEntity? = self.users.filter{ $0.user == to }.first

            if from == nil || to == nil {
                observer.onError(ErrorTransfer.userNotFound)
            }

            if !self.checkAmountOverflow(to!, amount: amount) {
                observer.onError(ErrorTransfer.amountOverflow)
            }

            if !self.checkInsufficientFunds(from!, amount: amount) {
                observer.onError(ErrorTransfer.amountOverflow)
            }

            self.credit(to!, amount: amount)
            self.debit(from!, amount: amount)

            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })



    }
}

extension MVVMModel {
    private func checkAmountOverflow(_ user: UserEntity, amount: Int) -> Bool {
        // 入金後の残高がIntの最大値を超過するかの判断を行う
        return user.balance.value > Int.max - amount
    }
    private func checkInsufficientFunds(_ user: UserEntity, amount: Int) -> Bool {
        // 出金後の残高が0を下回るかの判断を行う
        return user.balance.value - amount < 0
    }

    /**
     入金処理を行う

     - Parameters:
     - amount: 金額(Int)
     */
    private func credit(_ user: UserEntity, amount: Int) {
        // 金額を減算する
        user.balance.accept(user.balance.value + amount)
    }

    /**
     出金処理を行う

     - Parameters:
     - amount: 金額(Int)
     */
    private func debit(_ user: UserEntity, amount: Int) {
        // 金額を加算する
        user.balance.accept(user.balance.value - amount)
    }
}

extension MVVMModel {
    private func resetBalance(_ _users: [UserList]=UserList.allValues) {
        for user in _users {
            let initValue = UserList.find(user.rawValue)?.initValue ?? 0
            self.users.filter{ $0.user == user }.first?.balance.accept(initValue)
        }
    }

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

    private func update(_ entity: UserEntity) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        var stored: Dictionary<String, Any>? {
            return userDefaults.dictionary(forKey: key)
        }

        var dictionary: Dictionary<String, Any> = stored ?? Dictionary()

        dictionary[entity.user.rawValue] = entity.balance.value

        userDefaults.set(dictionary, forKey: key)
    }
}
