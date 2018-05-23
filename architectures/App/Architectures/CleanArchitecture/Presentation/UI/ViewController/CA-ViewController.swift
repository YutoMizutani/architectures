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
        reset()
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
    private func binding() {
        if let balanceToLabel = self.subview?.balanceToLabel.rx.text {
            self.aModel.balance
                .asObservable()
                .map { "\($0)" }
                .asDriver(onErrorJustReturn: "")
                .drive(balanceToLabel)
                .disposed(by: disposeBag)
        }
        
        if let balanceFromLabel = self.subview?.balanceFromLabel.rx.text {
            self.bModel.balance
                .asObservable()
                .map { "\($0)" }
                .asDriver(onErrorJustReturn: "")
                .drive(balanceFromLabel)
                .disposed(by: disposeBag)
        }

        self.subview?.transferButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.transfer(from: self?.getA(), to: self?.getB(), amount: 100)
//                self?.presenter?.begin()
            })
            .disposed(by: disposeBag)

        self.subview?.resetButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.reset()
//                self?.presenter?.end()
            })
            .disposed(by: disposeBag)
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

extension CAViewController: CAViewInput, ErrorShowable {
    func presentAlert(_ error: Error) {
        self.showAlert(error: error)
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
