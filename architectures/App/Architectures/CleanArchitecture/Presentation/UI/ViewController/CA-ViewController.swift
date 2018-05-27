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

    func updateModel(model: CAModel)
}

class CAViewController: UIViewController {
    typealias presenterType = CAPresenter

    private var presenter: presenterType?
    private var subview: CAView?

    private let users: (to: UserList, from: UserList) = (.takahashi, .watanabe)
    private var models: (to: CAModel, from: CAModel)!

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
        fetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 残高を取得する。
        self.fetch()
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
extension CAViewController {
    private func configureView() {
        selfview: do {
            self.view.backgroundColor = UIColor.white
        }
        subview: do {
            self.subview = CAView()
            if let subview = self.subview {
                subview.toView.nameLabel.text = "\(self.users.to.rawValue): "
                subview.fromView.nameLabel.text = "\(self.users.from.rawValue): "
                self.view.addSubview(subview)
            }
        }
    }

    private func configureModel() {
        self.models = (
            to: CAModelImpl(user: self.users.to, balance: 0),
            from: CAModelImpl(user: self.users.from, balance: 0)
        )
    }

    private func layoutView() {
        subview: do {
            self.subview?.frame = self.view.bounds
        }
    }

    /// 送金先のユーザー情報のバインディングを行う。
    private func toBind() {
        if let balanceToLabel = self.subview?.toView.valueLabel {
            self.models.to.balance
                .asObservable()
                .map { "\($0)" }
                .asDriver(onErrorJustReturn: "")
                .drive(balanceToLabel.rx.text)
                .disposed(by: disposeBag)
        }
    }

    /// 送金元のユーザー情報のバインディングを行う。
    private func fromBind() {
        if let balanceFromLabel = self.subview?.fromView.valueLabel {
            self.models.from.balance
                .asObservable()
                .map { "\($0)" }
                .asDriver(onErrorJustReturn: "")
                .drive(balanceFromLabel.rx.text)
                .disposed(by: disposeBag)
        }
    }

    /// バインディングを行う
    private func binding() {
        self.toBind()
        self.fromBind()

        // 送金ボタンを設定する。
        self.subview?.transferButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.transfer()
            })
            .disposed(by: disposeBag)

        // 初期化ボタンを設定する。
        self.subview?.resetButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.reset()
            })
            .disposed(by: disposeBag)
    }
}

// MARK:- Private methods to presenters
extension CAViewController {
    private func fetch() {
        self.presenter?.fetch([self.models.to, self.models.from])
    }

    @IBAction func transfer() {
        self.presenter?.transfer(from: self.models.from, to: self.models.to, amount: Assets.amount)
    }

    @IBAction func reset() {
        self.presenter?.reset([self.models.to, self.models.from])
    }
}

// MARK:- Public methods accessed from other classes
extension CAViewController: CAViewInput, ErrorShowable {
    public func presentAlert(_ error: Error) {
        self.showAlert(error: error)
    }

    public func updateModel(model: CAModel) {
        if self.models.to.user == model.user {
            self.models.to = model
            self.toBind()
        }else if self.models.from.user == model.user {
            self.models.from = model
            self.fromBind()
        }
    }
}
