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
    private weak var view: MVPViewInterface?
    private let model: MVPModel

    init(view: MVPViewInterface, model: MVPModel) {
        self.view = view
        self.model = model
    }
}

extension MVPPresenter {
    /// Model要素を更新する。
    func fetch() {
        // Model要素を更新する。
        self.model.fetch()

        // Viewを更新する。
        self.view?.updateView(model: self.model)
    }

    func transfer() {
        do {

            // 送金処理を行う。
            try self.model.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount)

            // Viewを更新する。
            self.view?.updateView(model: self.model)

        } catch let e {

            // エラーをアラートに表示する。
            self.view?.presentError(error: e)

        }
    }

    func reset() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // Userを元にリセットを行う。
        self.model.reset(users)

        // Viewを更新する。
        self.view?.updateView(model: self.model)
    }
}
