//
//  CA-ViewController.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CAViewInput: class {

}


class CAViewController: UIViewController {
    typealias presenterType = CAPresenter

    private var presenter: presenterType?
    private var subview: CAView?

    private let disposeBag = DisposeBag()

    internal func inject(
        presenter: presenterType
        ) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layoutView()
        binding()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutView()

        self.view.layoutIfNeeded()
    }
}

extension CAViewController {
    private func configureView() {
        selfview: do {
            self.view.backgroundColor = UIColor.white
        }
        subview: do {
            self.subview = CAView(frame: self.view.bounds)
            if self.subview != nil {
                self.view.addSubview(self.subview!)
            }
        }
    }
    private func layoutView() {
        subview: do {
            self.subview?.frame = self.view.bounds
        }
    }
}

extension CAViewController {
    private func binding() {

    }
}

extension CAViewController: CAViewInput {

}
