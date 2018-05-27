//
//  DDD-Application.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 アプリケーション層
    ソフトウェアが行うことになっている仕事を定義し，表現豊かなドメインオブジェクトが問題を解決するように導く。このレイヤが責務を負う作業は，ビジネスにとって意味があるものか，あるいは他システムのアプリケーション層と相互作用するのに必要なものである。
    このレイヤは薄く保たれる。ビジネスルールや知識を含まず，やるべき作業を調整するだけで，実際の処理は，ドメインオブジェクトによって直下のレイヤで実行される共同作業に委譲する。ビジネスの状況を反映する状態は持たないが，ユーザやプログラムが行う作業の進捗を反映する状態を持つことはできる。

 『エリック・エヴァンスのドメイン駆動設計』より

 */

import Foundation

class DDDApplication {
    /// Domainの定義
    private(set) var domain: DDDDomain!
    /// Infrastructureの定義
    let infrastructure: DDDInfrastructure!

    init(_ users: [UserList]) {
        self.domain = DDDDomain(users)
        self.infrastructure = DDDInfrastructure()
    }
}

extension DDDApplication {
    /**
     UserListを元に残高を取得する。

     - Parameters:
        - user: 残高を取得するユーザー

     - returns:
        - 残高(Optional)
     */
    public func getBalance(_ user: UserList) -> Int? {
        return self.domain.getEntity(user)?.balance
    }

    /**
     Infrastructure経由でDomainを更新する。

     - throws: Userが見つからなかった場合
     */
    public func fetch() throws {
        // InfrastructureへEntityの取得を依頼する。
        let entities = try self.infrastructure.fetchEntity()

        // 取得したEntityを元にDomainを更新する。
        self.domain = DDDDomain(entities)
    }

    /**
     Infrastructure経由でDomainを初期化する。
     */
    public func reset() {
        // Infrastructureへ初期化されたEntityを依頼する。
        let entities = self.infrastructure.reset(self.domain.entities)

        // 取得したEntityを元にDomainを更新する。
        self.domain = DDDDomain(entities)
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
    public func transfer(_ amount: Int, from: UserList, to: UserList) throws {
        // Domainに送金を依頼する。
        try self.domain.transfer(from: from, to: to, amount: amount)

        // Infrastructureへ更新を依頼する。
        self.infrastructure.commit(self.domain.entities)
    }
}
