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
    func translate(from entity: CAEntity) -> CAModel
}

struct CATranslatorImpl: CATranslator {
    func translate(from model: CAModel) -> CAEntity {
        return CAEntityImpl(id: model.id)
    }
    func translate(from entity: CAEntity) -> CAModel {
        return CAModelImpl(id: entity.id)
    }
}
