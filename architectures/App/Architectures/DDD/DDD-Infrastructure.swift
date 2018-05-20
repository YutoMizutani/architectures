//
//  DDD-Infrastructure.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 インフラストラクチャ層
    上位のレイヤを支える一般的な技術的機能を提供する。これには，アプリケーションのためのメッセージ送信，ドメインのための永続化，ユーザーインターフェースのためのウィジェット描画などがある。インフラストラクチャ層は，ここで示す4階層における相互作用のパターンも，アーキテクチャフレームワークを通じてサポートすることがある。

 『エリック・エヴァンスのドメイン駆動設計』より

 */

import Foundation

class DDDInfrastructure {
}

extension DDDInfrastructure {
    public func beginTranaction() throws {
        try self.beginLocking()
    }

    public func getDomains() throws -> [DDDDomain] {
        guard let dictionary = self.fetch() else { throw ErrorTransfer.userNotFound }
        return try self.translate(dictionary)
    }

    public func commit(_ collections: Accounts) {
        let dictionary = self.translate(collections)
        self.update(dictionary)
    }
}

extension DDDInfrastructure {
    private func translate(_ dictionary: Dictionary<String, Any>) throws -> [DDDDomain] {
        var domains: [DDDDomain] = []

        for d in dictionary {
            if type(of: d.value) != Int.self {
                throw ErrorTransfer.storedTypeInvalid
            }

            let domain = DDDDomain(name: d.key, balance: d.value as! Int)

            domains.append(domain)
        }

        return domains
    }
}

extension DDDInfrastructure {
    private func translate(_ collections: Accounts) -> Dictionary<String, Any> {
        var dictionary: Dictionary<String, Any> = [:]

        for c in collections {
            dictionary[c.key] = c.value
        }

        return dictionary
    }
}

extension DDDInfrastructure {
    private func beginLocking() throws {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.lockingState.rawValue

        let state = userDefaults.bool(forKey: key)
        if state {
            throw ErrorTransfer.transactionLocking
        }

        userDefaults.set(true, forKey: key)
    }

    private func endLocking() {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.lockingState.rawValue

        userDefaults.set(false, forKey: key)
    }

    private func fetch() -> Dictionary<String, Any>? {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        if userDefaults.object(forKey: key) == nil {
            return nil
        }

        return userDefaults.dictionary(forKey: key)
    }

    private func update(_ dictionary: Dictionary<String, Any>) {
        let userDefaults: UserDefaults = UserDefaults.standard

        userDefaults.set(dictionary, forKey: UserDefaultsKeys.account.rawValue)
    }
}
