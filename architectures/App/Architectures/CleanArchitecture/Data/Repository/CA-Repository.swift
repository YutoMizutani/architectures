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
    func fetch() -> Observable<[CAEntity]>
    func commit(_ entities: [CAEntity]) -> Observable<Void>
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

// MARK:- Public methods accessed from other classes
extension CARepositoryImpl: CARepository {
    /// DataStoreから更新を取得する。
    public func fetch() -> Observable<[CAEntity]> {
        return self.dataStore.fetch()
    }

    /// DataStoreへ更新を実行する。
    public func commit(_ entities: [CAEntity]) -> Observable<Void> {
        return self.dataStore.update(entities)
    }
}
