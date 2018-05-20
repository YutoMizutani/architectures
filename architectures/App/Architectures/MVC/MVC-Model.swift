//
//  MVC-Model.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

class MVCModel {
    private(set) var count: Int = 0
}

extension MVCModel {
    public func countUp() -> Int {
        self.count += 1
        return self.count
    }

    public func resetCount() -> Int {
        self.count = 0
        return self.count
    }
}
