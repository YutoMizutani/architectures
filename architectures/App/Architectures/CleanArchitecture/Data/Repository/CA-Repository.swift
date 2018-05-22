//
//  CA-Repository.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift

protocol CARepository {
    func beginLocking() -> Observable<Any>
    func endLocking() -> Observable<Any>

    func fetch() -> Observable<[CAEntity]>
    func commit(_ entities: [CAEntity]) -> Observable<Any>
}


struct CARepositoryImpl {
    typealias dataStoreType = CADataStore

    private let dataStore: dataStoreType

    init(
        dataStore: dataStoreType
        ) {
        self.dataStore = dataStore
    }
}

extension CARepositoryImpl: CARepository {
    func beginLocking() -> Observable<Any> {
        return self.dataStore.beginLocking()
    }

    func endLocking() -> Observable<Any> {
        return self.endLocking()
    }

    func fetch() -> Observable<[CAEntity]> {
        return self.dataStore.fetch()
    }

    func commit(_ entities: [CAEntity]) -> Observable<Any> {
        return self.dataStore.update(entities)
    }
}
