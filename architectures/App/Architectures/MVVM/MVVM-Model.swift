//
//  MVVM-Model.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 Model（モデル）
    Modelはアプリケーションのドメインモデルを指します。データ構造のほかビジネスロジックを表現する手段もモデルに含まれます

 『Android アプリ設計パターン入門』より

 */

import Foundation
import RxSwift
import RxCocoa

class MVVMModel {
    private(set) var balance: BehaviorRelay<Int> = BehaviorRelay(value: 0)
}

extension MVVMModel {
    public func transfer() {
//        let currentValue = self.count.value
//        self.count.accept(currentValue + 1)
    }

    public func resetCount() {
//        self.count.accept(0)
    }
}
