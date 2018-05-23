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
    var myview: View = View()
    var application: DDDApplication = DDDApplication()
}

extension DDDUserInterface {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureControl()
        layoutView()
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
    private func configureView() {
        self.view.addSubview(self.myview)
    }

    private func configureControl() {
        self.myview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
        self.myview.resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
    }

    private func layoutView() {
        self.myview.frame = self.view.frame
    }
}

extension DDDUserInterface: ErrorShowable {
    @IBAction func transfer() {
        do {
            try self.application.transfer(Assets.amount, from: .takahashi, to: .watanabe)
        } catch let e {
            self.showAlert(error: e)
        }
    }

    @IBAction func reset() {
//        self.application.reset()
    }
}
