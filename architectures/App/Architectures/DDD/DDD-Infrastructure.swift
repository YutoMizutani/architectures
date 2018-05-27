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

// MARK:- Public methods accessed from other classes
extension DDDInfrastructure {
    /**
     Entityを取得する。

     - returns:
        ユーザー情報
     - throws:
        ユーザーが存在しなかった場合
     */
    public func fetchEntity() throws -> [DDDUserEntity] {
        // Userを取得する
        guard let dictionary = self.fetch() else { throw ErrorTransfer.userNotFound }

        // Entity型に変換して返す。
        return try self.translate(dictionary)
    }

    /**
     指定されたユーザーの初期化を行う。

     - Parameters:
        - collections: ユーザー情報

     - returns:
        ユーザー情報
     */
    public func reset(_ collections: [DDDUserEntity]) -> [DDDUserEntity] {
        // 初期化を行う。
        let newCollections = self.getInitValue(collections)

        // 保存する。
        self.commit(newCollections)

        return newCollections
    }

    /**
     ユーザー情報の更新を行う。

     - Parameters:
        - collections: ユーザー情報
     */
    public func commit(_ collections: [DDDUserEntity]) {
        // dictionary型に変換して保存する。
        let dictionary = self.translate(collections)
        self.update(dictionary)
    }
}

// MARK:- Private methods about business logics

// MARK:- Private methods about initialize
extension DDDInfrastructure {
    /**
     指定されたユーザーの初期化を行う。

     - Parameters:
        - collections: ユーザー情報

     - returns:
        ユーザー情報
     */
    private func getInitValue(_ collections: [DDDUserEntity]) -> [DDDUserEntity] {
        let users = collections.map{ $0.user }

        return DDDUserFactory.create(users: users)
    }
}

// MARK:- Private methods about translate
extension DDDInfrastructure {
    /**
     UserDefaultsから取得したデータをEntityに変換する。

     - Parameters:
        - dictionary: Dictionary型のユーザー情報

     - returns:
        Entity型のユーザー情報

     - throws:
        ユーザーが見つからなかった場合，型変換に失敗した場合
     */
    private func translate(_ dictionary: Dictionary<String, Any>) throws -> [DDDUserEntity] {
        var entities: [DDDUserEntity] = []

        for d in dictionary {

            // ユーザーを検索する。
            guard let user = UserList.find(d.key) else {
                throw ErrorTransfer.userNotFound
            }

            // AnyをIntに変換する。
            guard let balance = d.value as? Int else {
                throw ErrorTransfer.storedTypeInvalid
            }

            // Factoryを元に生成する。
            let entity = DDDUserFactory.create(user: user, balance: balance)

            entities.append(entity)
        }

        return entities
    }

    /**
     UserDefaultsから取得したデータをEntityに変換する。

     - Parameters:
        - entities: Entity型のユーザー情報

     - returns:
        Dictionary型のユーザー情報
     */
    private func translate(_ entities: [DDDUserEntity]) -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for c in entities {
            dictionary[c.user.rawValue] = c.balance
        }

        return dictionary
    }
}

// MARK:- Private methods about userdefaults
extension DDDInfrastructure {
    /**
     UserDefaultsからデータを取得する。

     - returns:
        Dictionary型のユーザー情報
     */
    private func fetch() -> Dictionary<String, Any>? {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        return userDefaults.dictionary(forKey: key)
    }


    /**
     UserDefaultsへデータを保存する。

     - Parameters:
        - dictionary: Dictionary型のユーザー情報
     */
    private func update(_ dictionary: Dictionary<String, Any>) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        userDefaults.set(dictionary, forKey: key)
    }
}
