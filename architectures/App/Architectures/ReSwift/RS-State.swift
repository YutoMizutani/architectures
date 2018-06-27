//
//  RS-State.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import ReSwift

struct RSState: StateType {
    var to: (user: UserList, balance: Int)?
    var from: (user: UserList, balance: Int)?
    var error: Error?
}

extension RSState {
    static var empty: RSState {
        return RSState(to: nil, from: nil, error: nil)
    }
}
