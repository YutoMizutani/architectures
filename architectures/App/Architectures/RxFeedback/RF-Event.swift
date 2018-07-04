//
//  RF-Event.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum RFEvent {
    case stabilize
    case fetch
    case update(RFTransfer)
    case reset
    case transfer(to: UserList, from: UserList, amount: Int)
}
