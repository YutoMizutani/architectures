//
//  CA-Model.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CAModel {
    var user: UserList { get }
    var balance: BehaviorRelay<Int> { get }
}


struct CAModelImpl: CAModel {
    let user: UserList
    private(set) var balance: BehaviorRelay<Int>

    init(user: UserList, balance: Int) {
        self.user = user
        self.balance = BehaviorRelay(value: balance)
    }
}
