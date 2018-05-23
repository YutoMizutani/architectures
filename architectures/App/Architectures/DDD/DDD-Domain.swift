//
//  DDD-Domain.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 ドメイン層（またはモデル層）
    ビジネスの概念と，ビジネスが置かれた状況に関する情報，およびビジネスルールを表す責務を負う。ビジネスの状況を反映する状態はここで制御され使用されるが，それを格納するという技術的な詳細は，インフラストラクチャに委譲される。この層がビジネスソフトウェアの核心である。

 『エリック・エヴァンスのドメイン駆動設計』より

 */

import Foundation

class DDDDomain {
    public let user: UserList
    public private(set) var balance: Int

    init(user: UserList, balance: Int) {
        self.user = user
        self.balance = balance
    }
}

extension DDDDomain {
    /**
     送金処理を行う

     - Parameters:
        - to: 送金先(DDDomain)
        - amount: 金額(Int)

     - throws: 入出金後の残高に過不足が生じた場合
     */
    public func transfer(to: DDDDomain, amount: Int) throws {
        // 送信先へ入金処理を行う
        try to.credit(amount)

        // 残高から出金処理を行う
        try self.debit(amount)
    }
}

extension DDDDomain {
    /**
     入金処理を行う

     - Parameters:
        - amount: 金額(Int)

     - throws: Intの最大値を超過する場合
     */
    private func credit(_ amount: Int) throws {
        // 入金後の残高がIntの最大値を超過するかの判断を行う
        if self.balance > Int.max - amount {
            throw ErrorTransfer.amountOverflow
        }

        // 金額を加算する
        self.balance += amount
    }

    /**
     出金処理を行う

     - Parameters:
        - amount: 金額(Int)

     - throws: Intの最大値を超過する場合
     */
    private func debit(_ amount: Int) throws {
        // 出金後の残高が0を下回かの判断を行う
        if self.balance - amount > 0 {
            throw ErrorTransfer.insufficientFunds
        }

        // 金額を減算する
        self.balance -= amount
    }
}
