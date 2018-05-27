//
//  DDD-UserInterface.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 ユーザーインターフェイス（またはプレゼンテーション層）
    ユーザに情報を表示して，ユーザのコマンドを解釈する責務を負う。外部アクタは人間のユーザではなく，別のコンピュータシステムのこともある。

 『エリック・エヴァンスのドメイン駆動設計』より

 */

import UIKit

class DDDUserInterface: UIViewController {
    var subview: View!
    var application: DDDApplication!
}

extension DDDUserInterface {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureApplication()
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

extension DDDUserInterface {
    /// Viewの構成を行う.
    private func configureView() {
        // Viewを作成する。
        self.subview = View()

        // Viewに表示されるラベルの名前を設定する。
        self.subview.toView.nameLabel.text = "\(UserList.takahashi.rawValue): "
        self.subview.fromView.nameLabel.text = "\(UserList.watanabe.rawValue): "

        // Viewを追加する。
        self.view.addSubview(self.subview)
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }

    /// Applicationの構成を行う
    private func configureApplication() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // Userを元にApplicationを生成する
        self.application = DDDApplication(users)
    }

    private func addAction() {
        self.subview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
        self.subview.resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
    }
}

extension DDDUserInterface {
    /// Viewの更新を行う。
    private func updateView() {
        // メインスレッドでラベルの値を更新する。
        DispatchQueue.main.async {
            self.subview.toView.valueLabel.text = "\(self.application.getBalance(.takahashi) ?? 0)"
            self.subview.fromView.valueLabel.text = "\(self.application.getBalance(.watanabe) ?? 0)"
        }
    }
}

extension DDDUserInterface: ErrorShowable {
    /// Valueを取得する。
    private func fetchValue() {
        do {

            // Model要素を更新する。
            try self.application.fetch()

        } catch let e {

            // エラーが生じた場合はアラートを表示する。
            self.showAlert(error: e)

        }

        // Viewを更新する。
        self.updateView()
    }

    /// 送金を行う
    @IBAction func transfer() {
        do {

            try self.application.transfer(Assets.amount, from: .watanabe, to: .takahashi)

            // Viewを更新する。
            self.updateView()

        } catch let e {

            // エラーが生じた場合はアラートを表示する。
            self.showAlert(error: e)

        }
    }

    /// リセットを行う
    @IBAction func reset() {
        // Application層にリセットを要求する
        self.application.reset()

        // Viewを更新する。
        self.updateView()
    }
}
