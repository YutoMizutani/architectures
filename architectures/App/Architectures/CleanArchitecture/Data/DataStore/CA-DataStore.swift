//
//  CA-DataStore.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol CADataStore {
    func fetch(_ closure: (CAEntity) -> Void) throws 
}

struct CADataStoreImpl: CADataStore {
    func fetch(_ closure: (CAEntity) -> Void) throws  {
        // you can write get entity method
    }
}
