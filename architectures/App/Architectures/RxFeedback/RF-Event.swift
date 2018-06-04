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
//
//public extension RFEvent {
//    /// textと一致するEventを返す。
//    public static func throwState(_ text: String) -> RFEvent {
//        switch text.lowercased() {
//        case "goStart".lowercased(), "start".lowercased(), "s":
//            return .goStart
//        case "goSleep".lowercased(), "sleep".lowercased():
//            return .goSleep
//        case "goWakeUp".lowercased(), "wakeUp".lowercased():
//            return .goWakeUp
//        case "goEnd".lowercased(), "end".lowercased():
//            return .goEnd
//        case "response".lowercased(), "r":
//            return .response
//        default:
//            return .noChange
//        }
//    }
//}
