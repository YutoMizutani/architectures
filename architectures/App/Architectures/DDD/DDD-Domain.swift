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
    private(set) var entities: [DDDUserEntity]

    init(_ users: [UserList]) {
        self.entities = DDDUserFactory.create(users: users)
    }

    init(_ entities: [DDDUserEntity]) {
        self.entities = entities
    }
}

// MARK:- Public methods accessed from other classes
extension DDDDomain {
    /**
     UserListでフィルタされたEntityを取得する。

     - Parameters:
        - user: 取得するユーザー

     - returns:
        ユーザーのEntity(Optional)
     */
    public func getEntity(_ user: UserList) -> DDDUserEntity? {
        return self.entities.filter({ entity -> Bool in
            entity.user == user
        }).first
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
        let backup = self.entities
        do {
            // 送信先へ入金処理を行う
            try self.credit(to, amount: amount)

            // 残高から出金処理を行う
            try self.debit(from, amount: amount)

        }catch let e {

            // Error発生時は処理前に巻き戻す。
            self.entities = backup

            // Errorを上の階層に投げる。
            throw e

        }
    }
}


// MARK:- Private methods about business logics
extension DDDDomain {
    /**
     入金処理を行う

     - Parameters:
        - to: ユーザー
        - amount: 金額

     - throws: Intの最大値を超過する場合
     */
    private func credit(_ to: UserList, amount: Int) throws {
        // Entityに存在するかフィルタリングする。
        guard let to = self.entities.filter({ entity -> Bool in
            entity.user == to
        }).first else { throw ErrorTransfer.userNotFound }

        // 入金後の残高がIntの最大値を超過するかの判断を行う
        if to.balance > Int.max - amount {
            throw ErrorTransfer.amountOverflow
        }

        // 金額を加算する。
        to.balance += amount
    }

    /**
     出金処理を行う

     - Parameters:
        - from: ユーザー
        - amount: 金額

     - throws: 0を下回る場合
     */
    private func debit(_ from: UserList, amount: Int) throws {
        // Entityに存在するかフィルタリングする。
        guard let from = self.entities.filter({ entity -> Bool in
            entity.user == from
        }).first else { throw ErrorTransfer.userNotFound }

        // 出金後の残高が0を下回るかの判断を行う
        if from.balance - amount < 0 {
            throw ErrorTransfer.insufficientFunds
        }

        // 金額を減算する。
        from.balance -= amount
    }
}
