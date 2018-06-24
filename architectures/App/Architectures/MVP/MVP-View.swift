//
//  MVP-View.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 View（ビュー）
    Modelで定義したデータを表示し，イベントをプレゼンターへ伝えます。表示処理を行う受動的なインターフェイスです

 『Android アプリ設計パターン入門』より

 */

import UIKit

protocol MVPViewInterface: class {
    func updateView(model: MVPModel)
    func presentError(error: Error)
}

class MVPView: UIViewController {
    // ViewとModelを保持する。
    var subview: View!
    var presenter: MVPPresenter!
}

extension MVPView {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configurePresenter()
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
extension MVPView {
    /// Viewの構成を行う。
    private func configureView() {
        // Viewを作成する。
        self.subview = View()

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

    // Presenterの構成を行う。
    private func configurePresenter() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // UserLisetを元にModelを作成する。
        let model = MVPModel(users: users)

        // Presenterを作成する。
        self.presenter = MVPPresenter(view: self, model: model)
    }

    /// ボタン押下時のアクションを設定する。
    private func addAction() {
        self.subview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
        self.subview.resetButton.addTarget(self, action: #selector(self.resetCount), for: .touchUpInside)
    }
}

extension MVPView {
    private func fetchValue() {
        // Model要素を更新する。
        self.presenter.fetch()
    }
}

extension MVPView: ErrorShowable {
    @IBAction func transfer() {
        // 送金処理を行う。
        self.presenter.transfer()
    }

    @IBAction func resetCount() {
        // Userを元にリセットを行う。
        self.presenter.reset()
    }
}

extension MVPView: MVPViewInterface {
    /// Viewを更新する。
    func updateView(model: MVPModel) {
        // メインスレッドでラベルの値を更新する。
        DispatchQueue.main.async {
            self.subview.toView.valueLabel.text = "\(model.accounts[UserList.takahashi.rawValue] ?? 0)"
            self.subview.fromView.valueLabel.text = "\(model.accounts[UserList.watanabe.rawValue] ?? 0)"
        }
    }

    /// エラーが生じた場合にアラートを表示する。
    func presentError(error: Error) {
        self.showAlert(error: error)
    }
}
