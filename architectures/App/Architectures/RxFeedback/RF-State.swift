//
//  RF-State.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum RFState {
    case ready

    case balanceWillChange(RFTransfer)
    case balanceDidChange(RFTransfer)
}

public extension RFState {
    static var initialState: RFState {
        return RFState.ready
    }
}

extension RFState {
    private var index: Int {
        switch self {
        case .ready:
            return 0
        case .balanceWillChange(_):
            return 1
        case .balanceDidChange(_):
            return 2
        }
    }

    public static func == (lhs: RFState, rhs: RFState) -> Bool {
        return lhs.index == rhs.index
    }
}
