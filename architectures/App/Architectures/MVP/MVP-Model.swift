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
    // ユーザー名を保持するArray
    let users: [UserList]
    // ユーザー名と口座情報を保持するDictionary
    var accounts: Accounts

    init(users: [UserList]) {
        self.users = users
        self.accounts = Accounts()
        self.configureAccounts()
    }
}

// MARK:- Private methods about settings
extension MVPModel {
    private func configureAccounts() {
        // ユーザー名を登録する。
        for user in self.users {
            self.accounts[user.rawValue] = 0
        }
    }
}
