//
//  CA-Model.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxCocoa

protocol CAModel {
    var user: UserList { get }
    var balance: BehaviorRelay<Int> { get }
}

struct CAModelImpl: CAModel {
    // ユーザー
    let user: UserList
    // 残高
    private(set) var balance: BehaviorRelay<Int>

    init(user: UserList, balance: Int) {
        self.user = user
        self.balance = BehaviorRelay(value: balance)
    }
}
