//
//  RF-State.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum RFState {
    case begin
    case ready

    case balanceWillChange(RFTransfer?)
    case balanceDidChange(RFTransfer?)
}

public extension RFState {
    static var initialState: RFState {
        return RFState.begin
    }
}

public extension RFState {
    public var index: Int {
        switch self {
        case .begin:
            return 0
        case .ready:
            return 1
        case .balanceWillChange(_):
            return 2
        case .balanceDidChange(_):
            return 3
        }
    }

    public static func == (lhs: RFState, rhs: RFState) -> Bool {
        return lhs.index == rhs.index
    }
}

public extension RFState {
    public var transfer: RFTransfer? {
        switch self {
        case .balanceWillChange(let t), .balanceDidChange(let t):
            return t
        default:
            return nil
        }
    }
}
