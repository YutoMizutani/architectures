//
//  MVC-Controller.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class MVCController: UIViewController {
    var myview: MVCView = MVCView()
    var model: MVCModel = MVCModel()
}

extension MVCController {
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
}

extension MVCController {
    private func configureView() {
        self.view.addSubview(self.myview)
    }
    
    private func layoutView() {
        self.myview.frame = self.view.frame
        self.myview.layoutView()
    }
}
