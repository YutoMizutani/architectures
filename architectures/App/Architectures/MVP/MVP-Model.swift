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
    var accounts: Accounts

    init(accounts: Accounts) {
        self.accounts = accounts
    }
}

extension MVPModel {
    public func transfer(_ amount: Int, from: String, to: String) {
    }
}

extension MVPModel {
    private func credit(_ amount: Int, account: String) {

    }

    private func debit(_ amount: Int, account: String) {

    }
}
