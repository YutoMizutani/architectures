//
//  MVP-Presenter.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 Presenter（プレゼンター）
    ModelとViewを操作します。Modelからデータを取得し，Viewに表示するためのロジックを担当します

 『Android アプリ設計パターン入門』より

 */

import UIKit

class MVPPresenter {
    private weak var view: MVPViewInterface?
    private var model: MVPModel

    init(view: MVPViewInterface, model: MVPModel) {
        self.view = view
        self.model = model
        self.fetch()
    }
}

// MARK:- Public methods accessed from other classes
extension MVPPresenter {
    /// Model要素を更新する。
    public func fetch() {
        // Model要素を更新する。
        self.fetchBalance(self.model.users)

        // Viewを更新する。
        self.view?.updateView(model: self.model)
    }

    /// 送金を行う。
    public func transfer() {
        do {

            // 送金処理を行う。
            try self.transferBalance(from: .watanabe, to: .takahashi, amount: Assets.amount)

            // 残高の更新を行う。
            self.update()

            // Viewを更新する。
            self.view?.updateView(model: self.model)

        } catch let e {

            // エラーをアラートに表示する。
            self.view?.presentError(error: e)

        }
    }

    // 残高を初期化する。
    func reset() {
        // Userを元にリセットを行う。
        self.resetBalance(self.model.users)

        // Viewを更新する。
        self.view?.updateView(model: self.model)
    }
}

// MARK:- Private methods about business logics

// MARK:- Private methods about transfer
extension MVPPresenter {
    /**
     送金を行う。

     - Parameters:
     - from: 送金元のユーザー
     - to: 送金先のユーザー
     - amount: 金額

     - Throws:
     ユーザーがリストに含まれない場合，取引元の残高が不足している場合，取引先の残高が超過する場合
     */
    private func transferBalance(from: UserList, to: UserList, amount: Int) throws {
        // ユーザー情報をリストから取得する。取引者がインスタンスに含まれない場合はエラーを出す。
        guard let fromBalance: Int = self.model.accounts[from.rawValue] else {
            throw ErrorTransfer.userNotFound
        }
        guard let toBalance: Int = self.model.accounts[to.rawValue] else {
            throw ErrorTransfer.userNotFound
        }

        // 取引先の残高が超過しないかチェックを行う。
        if self.isBalanceAmountOverflow(toBalance, amount: amount) {
            throw ErrorTransfer.amountOverflow
        }

        // 取引元の残高が不足しないかチェックを行う。
        if self.isBalanceInsufficientFunds(fromBalance, amount: amount) {
            throw ErrorTransfer.insufficientFunds
        }

        // 入金を行う。
        self.credit(to, amount: amount)
        // 出金を行う。
        self.debit(from, amount: amount)
    }

    /**
     取引後に残高超過に陥るかを判断する。

     - Parameters:
     - balance: 残高
     - amount: 金額

     - Returns:
     Bool (上回る場合，true)
     */
    private func isBalanceAmountOverflow(_ balance: Int, amount: Int) -> Bool {
        // 入金後の残高がIntの最大値を超過するかの判断を行う
        return balance > Int.max - amount
    }

    /**
     取引後に残高不足に陥るかを判断する。

     - Parameters:
     - balance: 残高
     - amount: 金額

     - Returns:
     Bool (下回る場合，true)
     */
    private func isBalanceInsufficientFunds(_ balance: Int, amount: Int) -> Bool {
        // 出金後の残高が0を下回るかの判断を行う
        return balance - amount < 0
    }

    /**
     入金処理を行う。

     - Parameters:
     - user: 対象ユーザー
     - amount: 金額
     */
    private func credit(_ user: UserList, amount: Int) {
        // 金額を加算する。
        self.model.accounts[user.rawValue]! += amount
    }

    /**
     出金処理を行う。

     - Parameters:
     - user: 対象ユーザー
     - amount: 金額
     */
    private func debit(_ user: UserList, amount: Int) {
        // 金額を減算する。
        self.model.accounts[user.rawValue]! -= amount
    }
}

// MARK:- Private methods about infrastructure
extension MVPPresenter {
    /**
     保存されている残高情報の取得を行う。

     - Parameters:
     - users: 取得を行うユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    private func fetchBalance(_ users: [UserList]=UserList.allValues) {
        let userDefaults = UserDefaults.standard

        // 口座情報を取得する。
        guard let dictionary = userDefaults.fetch() else {
            //  登録情報が存在しない場合，リセットを行う。
            self.resetBalance(users)
            return
        }

        // 口座の取得に失敗したユーザーを格納するリスト。
        var failedUsers: [UserList] = []

        for user in users {

            // 口座情報からユーザーを指定して残高情報を取り出す。
            guard let newValue = dictionary[user.rawValue] as? Int else {
                // 取得した口座情報が存在しない場合は口座取得失敗ユーザーに追加する。
                failedUsers.append(user)
                continue
            }

            // 一致するユーザーに対し，残高を更新する。
            if self.model.accounts[user.rawValue] != nil {
                self.model.accounts[user.rawValue] = newValue
            }

        }

        //  口座情報が存在しないユーザーに対し，リセットを行う。
        self.resetBalance(failedUsers)
    }

    /**
     残高をリセットする。

     - Parameters:
     - users: リセットを行うユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    private func resetBalance(_ users: [UserList]=UserList.allValues) {
        // ユーザーごとに処理する。
        for user in users {

            // 初期値を取得する。初期値が未登録の場合には0を指定する。
            let initValue = UserList.find(user.rawValue)?.initValue ?? 0

            // 一致するユーザーに対し，更新を呼ぶ。
            if self.model.accounts[user.rawValue] != nil {
                self.model.accounts[user.rawValue] = initValue
            }

        }
    }

    /**
     保存されている残高情報の更新を行う。
     */
    private func update() {
        let userDefaults: UserDefaults = UserDefaults.standard

        // UserDefaultsから全ての口座情報を取得する。保存されていなかった場合は空のDictionaryを生成する。
        var dictionary: Dictionary<String, Any> = userDefaults.fetch() ?? Dictionary()

        //
        for account in self.model.accounts {
            dictionary[account.key] = account.value
        }

        // 更新を保存する。
        userDefaults.update(dictionary)
    }
}

private extension UserDefaults {
    /// 口座情報のキー
    var key: String {
        return UserDefaultsKeys.account.rawValue
    }

    /**
     口座情報を取得する。

     - Returns:
     Dictionary\<String, Any\>?
     */
    func fetch() -> Dictionary<String, Any>? {
        // keyを元にdictionaryを取り出す。
        return self.dictionary(forKey: key)
    }

    /**
     口座情報を更新する。

     - Parameters:
     - dictionary: 保存する辞書型口座情報
     */
    func update(_ dictionary: Dictionary<String, Any>) {
        // keyを元に保存する。
        self.set(dictionary, forKey: key)
    }
}
