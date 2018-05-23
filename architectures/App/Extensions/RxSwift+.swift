//
//  RxSwift+.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public extension ObserverType where E == Void {
    public func onNext() {
        onNext(())
    }
}
