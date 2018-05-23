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
import RxSwift
import RxCocoa
import Eureka

class MVPPresenter: UIViewController {
    var myview: MVPView = MVPView()
    var model: MVPModel? = nil
}

extension MVPPresenter {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layoutView()
        addAction()
        setFirstValue()
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

extension MVPPresenter {
    private func configureView() {
        self.view.addSubview(self.myview)
    }

    private func layoutView() {
        self.myview.frame = self.view.frame
    }

    private func addAction() {
//        self.myview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
//        self.myview.resetButton.addTarget(self, action: #selector(self.resetCount), for: .touchUpInside)
    }

    private func setFirstValue() {
        let accounts = ""

        DispatchQueue.main.async {
//            self.myview..text = "0"
        }
    }
}

extension MVPPresenter {
    private func fetch() {

    }
}

extension MVPPresenter {
    @IBAction func countUp() {
//        let text = "\(self.model.countUp())"
//
//        DispatchQueue.main.async {
//            self.myview.displayLabel.text = text
//        }
    }

    @IBAction func resetCount() {
//        let text = "\(self.model.resetCount())"
//
//        DispatchQueue.main.async {
//            self.myview.displayLabel.text = text
//        }
    }
}
