//
//  MVP-Presenter.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 Presenter（プレゼンター）
    ModelとViewを操作します。Modelからデータを取得し，Viewに表示するためのロジックを担当します

 『Android アプリ設計パターン入門』より

 */

import UIKit

class MVPPresenter {
}

extension MVPPresenter {
    private func fetchValue(_ model: MVPModel) {
        // Model要素を更新する。
        model.fetch()
    }
}

extension MVPPresenter {
    func transfer(_ model: MVPModel) throws {
        // 送金処理を行う。
        try model.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount)
    }

    func reset(_ model: MVPModel) {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // Userを元にリセットを行う。
        model.reset(users)
    }
}
