//
//  MVP-Model.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 Model（モデル）
    UIに関わるデータを定義し，データ構造を提供するインターフェイスです

 『Android アプリ設計パターン入門』より

 */

import Foundation

class MVPModel {
    // ユーザー名と口座情報を保持するDictionary
    private(set) var accounts: Accounts

    init(users: [UserList]) {
        self.accounts = Accounts()
        self.configureAccounts(users)
    }
}

// MARK:- Private methods about settings
extension MVPModel {
    private func configureAccounts(_ users: [UserList]) {
        // ユーザー名を登録する。
        for user in users {
            self.accounts[user.rawValue] = 0
        }

        // 登録ユーザーを元に更新を行う。
        self.fetch(users)
    }
}

// MARK:- Public methods accessed from other classes
extension MVPModel {
    /**
     残高を取得する。

     - Parameters:
        - users: 取得を行うユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    public func fetch(_ users: [UserList]=UserList.allValues) {
        self.fetchBalance(users)
    }

    /**
     残高をリセットする。

     - Parameters:
        - users: リセットを行うユーザーのリスト。省略した場合は全てのユーザーが指定される。
     */
    public func reset(_ users: [UserList]=UserList.allValues) {
        self.resetBalance(users)
    }

    /**
     送金を行う。

     - Parameters:
        - from: 送金元のユーザー
        - to: 送金先のユーザー
        - amount: 金額

     - Throws:
        ユーザーがリストに含まれない場合，取引元の残高が不足している場合，取引先の残高が超過する場合
     */
    public func transfer(from: UserList, to: UserList, amount: Int) throws {
        try self.transferBalance(from: from, to: to, amount: amount)
        self.update()
    }
}

// MARK:- Private methods about business logics

// MARK:- Private methods about transfer
extension MVPModel {
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
        guard let fromBalance: Int = self.accounts[from.rawValue] else {
            throw ErrorTransfer.userNotFound
        }
        guard let toBalance: Int = self.accounts[to.rawValue] else {
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
        self.accounts[user.rawValue]! += amount
    }

    /**
     出金処理を行う。

     - Parameters:
         - user: 対象ユーザー
         - amount: 金額
     */
    private func debit(_ user: UserList, amount: Int) {
        // 金額を減算する。
        self.accounts[user.rawValue]! -= amount
    }
}

// MARK:- Private methods about infrastructure
extension MVPModel {
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
            if self.accounts[user.rawValue] != nil {
                self.accounts[user.rawValue] = newValue
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
            if self.accounts[user.rawValue] != nil {
                self.accounts[user.rawValue] = initValue
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
        for account in self.accounts {
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
