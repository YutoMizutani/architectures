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
    var name: String { get }
    var balance: BehaviorRelay<Int> { get }
}


struct CAModelImpl: CAModel {
    let name: String
    private(set) var balance: BehaviorRelay<Int>

    init(name: String, balance: Int) {
        self.name = name
        self.balance = BehaviorRelay(value: balance)
    }
}
