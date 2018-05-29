//
//  PDS-Presentation.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class PDSPresentation: UIViewController {
    // ViewとDomainを保持する。
    var subview: View!
    var domain: PDSDomain!
}

extension PDSPresentation {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureDomain()
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
extension PDSPresentation {
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

    /// Domainの構成を行う。
    private func configureDomain() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // UserLisetを元にDomainを作成する。
        self.domain = PDSDomain(users: users)
    }

    /// ボタン押下時のアクションを設定する。
    private func addAction() {
        self.subview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
        self.subview.resetButton.addTarget(self, action: #selector(self.resetCount), for: .touchUpInside)
    }
}

extension PDSPresentation {
    private func fetchValue() {
        // Domain要素を更新する。
        self.domain.fetch()

        // Viewを更新する。
        self.updateView()
    }

    private func updateView() {
        // メインスレッドでラベルの値を更新する。
        DispatchQueue.main.async {
            self.subview.toView.valueLabel.text = "\(self.domain.accounts[UserList.takahashi.rawValue] ?? 0)"
            self.subview.fromView.valueLabel.text = "\(self.domain.accounts[UserList.watanabe.rawValue] ?? 0)"
        }
    }
}

extension PDSPresentation: ErrorShowable {
    @IBAction func transfer() {
        do {

            // 送金処理を行う。
            try self.domain.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount)

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
        self.domain.reset(users)

        // Viewを更新する。
        self.updateView()
    }
}
