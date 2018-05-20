//
//  Account.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/20.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum UserDefaultsKeys: String {
    case account = "Account"
    case lockingState = "LockingState"
}

public enum UserList: String {
    case a = "A"
    case b = "B"
}

public typealias Accounts = Dictionary<String, Int>
