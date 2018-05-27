//
//  CA-DataStore.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift

protocol CADataStore {
    func fetch() -> Observable<[CAEntity]>
    func update(_ entities: [CAEntity]) -> Observable<Void>
}

struct CADataStoreImpl: CADataStore {
    /// UserDefaultsから更新を取得する。
    func fetch() -> Observable<[CAEntity]> {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        return Observable.create { observer in
            // オブジェクトとして保存されているか確認する。
            if userDefaults.object(forKey: key) == nil {
                observer.onError(ErrorTransfer.noContent)
            }

            if let dictionary = userDefaults.dictionary(forKey: key) {

                do {

                    let entities = try self.parse(dictionary)

                    // 取得ができた場合は値を流す。
                    observer.onNext(entities)

                } catch let e {

                    // エラーが発生した場合はエラーを流す。
                    observer.onError(e)

                }

            } else {

                // 保存されていなければエラーとして流す。
                observer.onError(ErrorTransfer.noContent)

            }

            observer.onCompleted()

            return Disposables.create()
        }
    }

    /// UserDefaultsへ更新を実行する。
    func update(_ entities: [CAEntity]) -> Observable<Void> {
        let userDefaults: UserDefaults = UserDefaults.standard

        return Observable.create { observer in
            let dictionary = self.stringify(entities)

            // 保存する。
            userDefaults.set(dictionary, forKey: UserDefaultsKeys.account.rawValue)

            // 保存が完了したら流す。
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        }
    }
}

extension CADataStoreImpl {
    /// DictionaryをCAEntity arrayに変換する。
    private func parse(_ dictionary: Dictionary<String, Any>) throws -> [CAEntity] {
        var entities: [CAEntity] = []

        // dictionaryごとに処理する。
        for content in dictionary {

            // AnyからIntに変換する。
            if let balance = content.value as? Int {

                // エンティティを作成する。
                let entity = CAEntityImpl(name: content.key, balance: balance)
                entities.append(entity)

            } else {

                // 型変換に失敗した場合はエラーとする。
                throw ErrorTransfer.storedTypeInvalid

            }
        }

        return entities
    }

    /// CAEntity arrayをDictionaryに変換する。
    private func stringify(_ entities: [CAEntity]) -> Dictionary<String, Any> {
        var dictionary: Dictionary<String, Any> = [:]

        // entityごとに処理する。
        for entity in entities {
            dictionary[entity.name] = entity.balance
        }

        return dictionary
    }
}
