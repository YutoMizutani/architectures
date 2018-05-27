//
//  CA-Translator.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol CATranslator {
    func translate(from model: CAModel) -> CAEntity
    func translate(from entity: CAEntity) throws -> CAModel
}

struct CATranslatorImpl: CATranslator {
    /// ModelからEntityに変換する。
    func translate(from model: CAModel) -> CAEntity {
        return CAEntityImpl(name: model.user.rawValue, balance: model.balance.value)
    }

    /// EntityからModelに変換する。
    func translate(from entity: CAEntity) throws -> CAModel {
        guard let user = UserList.find(entity.name) else {
            throw ErrorTransfer.userNotFound
        }
        return CAModelImpl(user: user, balance: entity.balance)
    }
}
