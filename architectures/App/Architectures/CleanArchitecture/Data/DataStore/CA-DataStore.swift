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
    func fetch() -> Observable<[CAEntity]> {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        return Observable.create { observer in
            if userDefaults.object(forKey: key) == nil {
                observer.onError(ErrorTransfer.noContent)
            }

            if let dictionary = userDefaults.dictionary(forKey: key) {

                do {

                    let entities = try self.parse(dictionary)

                    observer.onNext(entities)

                } catch let e {

                    observer.onError(e)

                }

            } else {
                observer.onError(ErrorTransfer.noContent)
            }

            observer.onCompleted()

            return Disposables.create()
        }
    }

    func update(_ entities: [CAEntity]) -> Observable<Void> {
        let userDefaults: UserDefaults = UserDefaults.standard

        return Observable.create { observer in
            let dictionary = self.stringify(entities)

            userDefaults.set(dictionary, forKey: UserDefaultsKeys.account.rawValue)
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        }
    }
}

extension CADataStoreImpl {
    private func parse(_ dictionary: Dictionary<String, Any>) throws -> [CAEntity] {
        var entities: [CAEntity] = []

        for content in dictionary {

            if let balance = content.value as? Int {

                let entity = CAEntityImpl(name: content.key, balance: balance)
                entities.append(entity)

            } else {

                throw ErrorTransfer.storedTypeInvalid

            }
        }

        return entities
    }

    private func stringify(_ entities: [CAEntity]) -> Dictionary<String, Any> {
        var dictionary: Dictionary<String, Any> = [:]

        for entity in entities {
            dictionary[entity.name] = entity.balance
        }

        return dictionary
    }
}
