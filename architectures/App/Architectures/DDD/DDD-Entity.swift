//
//  DDD-Entity.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

class DDDUserEntity {
    let user: UserList
    var balance: Int

    fileprivate init(user: UserList, balance: Int) {
        self.user = user
        self.balance = balance
    }
}

class DDDUserFactory {
    /// UserListを元にEntityを作成する。
    static func create(user: UserList, balance: Int?=nil) -> DDDUserEntity {
        /// Entityを作成する。
        let balance = balance ?? user.initValue
        let entity = DDDUserEntity(user: user, balance: balance)

        return entity
    }

    /// UserList arrayを元にEntityを作成する。
    static func create(users: [UserList]) -> [DDDUserEntity] {
        var entities: [DDDUserEntity] = []

        // user毎にEntityを生成する。
        for user in users {
            let entity = DDDUserFactory.create(user: user)
            entities.append(entity)
        }

        return entities
    }
}
