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
    func presentAlert(_ error: Error)

    func setModel(_ user: UserList, model: CAModel)
}


class CAViewController: UIViewController {
    typealias presenterType = CAPresenter

    private var presenter: presenterType?
    private var subview: CAView?

    private var aModel: CAModel = CAModelImpl.init(name: "a", balance: 0)
    private var bModel: CAModel = CAModelImpl.init(name: "b", balance: 0)

    internal func inject(
        presenter: presenterType
        ) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layoutView()
        addAction()
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
            self.subview = CAView()
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
    private func addAction() {
        self.subview?.transferButton.addTarget(self, action: #selector(transfer), for: .touchUpInside)
        self.subview?.resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
//        self.subview?.rx.tap
//            .
    }
}

extension CAViewController {
    func getA() -> CAModel? {
        return self.aModel
    }
    func getB() -> CAModel? {
        return self.bModel
    }

    @IBAction func transfer() {
        self.presenter?.transfer(from: getA(), to: getB(), amount: 100)
    }

    @IBAction func reset() {
        self.presenter?.reset()
    }
}

extension CAViewController: CAViewInput {
    func presentAlert(_ error: Error) {
        UIAlertController.present(self, error: error)
    }

    func setModel(_ user: UserList, model: CAModel) {
        switch user {
        case .a:
            self.aModel = model
        case .b:
            self.bModel = model
        }
    }
}
