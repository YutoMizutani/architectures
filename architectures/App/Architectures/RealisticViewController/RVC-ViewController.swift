//
//  RVC-ViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/20.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*

 Realistic ViewController
 この規模で実装する最低限の機能。保存処理も含めない。
 この「最低限動く」VCにユーザー管理の分割や保存処理を追加したものが各アーキテクチャで再現される。

 */

class RVCViewController: UIViewController {
    var subview: View = View()

    let firstValue: (a: Int, b: Int) = (UserList.takahashi.initValue, UserList.watanabe.initValue)
    let balance: (a: BehaviorRelay<Int>, b: BehaviorRelay<Int>) = (BehaviorRelay(value: 0), BehaviorRelay(value: 0))

    let disposeBag = DisposeBag()
}

extension RVCViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layoutView()
        binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.reset()
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

extension RVCViewController {
    private func configureView() {
        self.view.addSubview(self.subview)
    }

    private func layoutView() {
        self.subview.frame = self.view.frame
    }

    private func binding() {
        self.balance.a
            .asObservable()
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(self.subview.toView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.balance.b
            .asObservable()
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(self.subview.fromView.valueLabel.rx.text)
            .disposed(by: disposeBag)

        self.subview.transferButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.transfer()
            })
            .disposed(by: disposeBag)

        self.subview.resetButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.reset()
            })
            .disposed(by: disposeBag)
    }
}

extension RVCViewController: ErrorShowable {
    /// bからaに送金を行う
    private func transfer() {
        let amount: Int = Assets.amount

        if self.balance.b.value - amount < 0 {
            self.showAlert(error: ErrorTransfer.insufficientFunds)
            return
        }

        self.balance.a.accept(self.balance.a.value + amount)
        self.balance.b.accept(self.balance.b.value - amount)
    }

    /// a，bを初期化する
    private func reset() {
        self.balance.a.accept(firstValue.a)
        self.balance.b.accept(firstValue.b)
    }
}
