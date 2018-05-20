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
    var domains: [DDDDomain] = []
    let infrastructure: DDDInfrastructure = DDDInfrastructure()
}

extension DDDApplication {
    public func transfer(_ amount: Int, from: String, to: String) throws {
        try self.infrastructure.beginTranaction()

        let fromDomain = try self.getDomain(from)
        let toDomain = try self.getDomain(to)

        try fromDomain.transfer(to: toDomain, amount: amount)

//        self.infrastructure.commit()
    }
}

extension DDDApplication {
    private func fetchDomain() throws -> [DDDDomain] {
        return try self.infrastructure.getDomains()
    }

    private func getDomain(_ name: String) throws -> DDDDomain {
        for domain in self.domains {
            if domain.name == name {
                return domain
            }
        }

        throw ErrorTransfer.userNotFound
    }
}

extension DDDApplication {
    private func beginTransaction() {
//        return DDDInfrastructure()
    }

    private func commit() {
//        return DDDInfrastructure()
    }
}
