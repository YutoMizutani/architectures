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

    private var takahashi: CAModel?
    private var watanabe: CAModel?

    private let disposeBag = DisposeBag()

    internal func inject(
        presenter: presenterType
        ) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureModel()
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

    private func configureModel() {
        takahashi: do {
            self.takahashi = CAModelImpl(user: .takahashi, balance: 0)
        }
        watanabe: do {
            self.watanabe = CAModelImpl(user: .watanabe, balance: 0)
        }
    }

    private func layoutView() {
        subview: do {
            self.subview?.frame = self.view.bounds
        }
    }

    private func binding() {
        if let balanceToLabel = self.subview?.balanceToLabel.rx.text {
            self.takahashi?.balance
                .asObservable()
                .map { "\($0)" }
                .asDriver(onErrorJustReturn: "")
                .drive(balanceToLabel)
                .disposed(by: disposeBag)
        }
        
        if let balanceFromLabel = self.subview?.balanceFromLabel.rx.text {
            self.watanabe?.balance
                .asObservable()
                .map { "\($0)" }
                .asDriver(onErrorJustReturn: "")
                .drive(balanceFromLabel)
                .disposed(by: disposeBag)
        }

        self.subview?.transferButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.transfer()
            })
            .disposed(by: disposeBag)

        self.subview?.resetButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.reset()
            })
            .disposed(by: disposeBag)
    }
}

extension CAViewController {
    @IBAction func transfer() {
        guard let takehashi = self.takahashi else { return }
        guard let watanabe = self.watanabe else { return }
        self.presenter?.transfer(from: takehashi, to: watanabe, amount: Assets.amount)
    }

    @IBAction func reset() {
        guard let takehashi = self.takahashi else { return }
        guard let watanabe = self.watanabe else { return }
        self.presenter?.reset([takehashi, watanabe])
    }
}

extension CAViewController: CAViewInput, ErrorShowable {
    func presentAlert(_ error: Error) {
        self.showAlert(error: error)
    }

    func setModel(_ user: UserList, model: CAModel) {
        switch user {
        case .takahashi:
            self.takahashi = model
        case .watanabe:
            self.watanabe = model
        }
    }
}
