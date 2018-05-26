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

class MVPPresenter: UIViewController {
    // ViewとModelを保持する。
    var subview: MVPView!
    var model: MVPModel!
}

extension MVPPresenter {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureModel()
        layoutView()
        addAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 残高を取得する。
        self.fetchValue()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutView()

        self.view.layoutIfNeeded()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        layoutView()
    }
}

// MARK:- Private methods about settings
extension MVPPresenter {
    /// Viewの構成を行う。
    private func configureView() {
        // Viewを作成する。
        self.subview = MVPView()

        // Viewに表示されるラベルの名前を設定する。
        self.subview.toView.nameLabel.text = "\(UserList.takahashi.rawValue): "
        self.subview.fromView.nameLabel.text = "\(UserList.watanabe.rawValue): "

        // Viewに追加する。
        self.view.addSubview(self.subview)
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }

    /// Modelの構成を行う。
    private func configureModel() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // UserLisetを元にModelを作成する。
        self.model = MVPModel(users: users)
    }

    /// ボタン押下時のアクションを設定する。
    private func addAction() {
        self.subview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
        self.subview.resetButton.addTarget(self, action: #selector(self.resetCount), for: .touchUpInside)
    }
}

extension MVPPresenter {
    private func fetchValue() {
        // Model要素を更新する。
        self.model.fetch()

        // Viewを更新する。
        self.updateView()
    }

    private func updateView() {
        // メインスレッドでラベルの値を更新する。
        DispatchQueue.main.async {
            self.subview.toView.valueLabel.text = "\(self.model.accounts[UserList.takahashi.rawValue] ?? 0)"
            self.subview.fromView.valueLabel.text = "\(self.model.accounts[UserList.watanabe.rawValue] ?? 0)"
        }
    }
}

extension MVPPresenter: ErrorShowable {
    @IBAction func transfer() {
        do {

            // 送金処理を行う。
            try self.model.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount)

            // Viewを更新する。
            self.updateView()

        }catch let e {

            // エラーが生じた場合はアラートを表示する。
            self.showAlert(error: e)

        }
    }

    @IBAction func resetCount() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // Userを元にリセットを行う。
        self.model.reset(users)

        // Viewを更新する。
        self.updateView()
    }
}
