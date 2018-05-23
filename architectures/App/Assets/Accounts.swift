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
}

public struct Assets {
    public static let amount: Int = 100
}

public enum UserList: String, EnumCollection {
    case takahashi = "Takahashi"
    case watanabe = "Watanabe"

    static func find(_ name: String) -> UserList? {
        for user in UserList.cases() {
            if user.rawValue == name {
                return user
            }
        }
        return nil
    }

    var initValue: Int {
        switch self {
        case .takahashi:
            return 0
        case .watanabe:
            return 10000
        }
    }
}

public typealias Accounts = Dictionary<String, Int>
