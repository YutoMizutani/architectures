//
//  PP-ViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class PPViewController: UIViewController {
    var subview: MVCView = MVCView()
    var model: MVCModel = MVCModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
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

    private func configureView() {
        self.view.addSubview(self.subview)
    }

    private func layoutView() {
        self.subview.frame = self.view.frame
    }
}
