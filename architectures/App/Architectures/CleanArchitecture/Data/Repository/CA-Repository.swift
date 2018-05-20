//
//  CA-Repository.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol CARepository {
    func fetch(_ closure: (CAEntity) -> Void) throws
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
    func fetch(_ closure: (CAEntity) -> Void) throws  {
        return try dataStore.fetch(closure)
    }
}
