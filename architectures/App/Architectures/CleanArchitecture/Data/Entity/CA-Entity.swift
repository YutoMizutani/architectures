//
//  CA-Entity.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol CAEntity {
    var name: String { get }
    var balance: Int { get }
}

struct CAEntityImpl: CAEntity {
    let name: String
    let balance: Int
}
