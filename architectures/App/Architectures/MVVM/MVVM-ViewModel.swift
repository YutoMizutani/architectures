//
//  MVVM-ViewModel.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

/*

 ViewModel（ビューモデル）
    ViewModelはModelとViewの仲介役です。表示にかかわるロジックを担当します。Modelを操作し，Viewが使いやすい形でデータを提供する役割があります

 『Android アプリ設計パターン入門』より

 */

import UIKit
import RxSwift
import RxCocoa

class MVVMViewModel: UIViewController {
    var myview: MVVMView = MVVMView()
    var model: MVVMModel?

    let disposeBag = DisposeBag()
}

extension MVVMViewModel {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureModel()
        layoutView()
        binding()
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

extension MVVMViewModel {
    private func configureView() {
        self.view.addSubview(self.myview)
    }

    private func configureModel() {
        let users: [UserList] = [.takahashi, .watanabe]
        self.model = MVVMModel.init(users: users)
        self.model?.fetch()
    }

    private func layoutView() {
        self.myview.frame = self.view.frame
    }
    
    private func binding() {
        self.model?.users.filter{ $0.user == .takahashi }.first?.balance
            .map{ "\($0)" }
            .asDriver(onErrorJustReturn: "Rx binding error!")
            .drive(self.myview.balanceToLabel.rx.text)
            .disposed(by: self.disposeBag)

        self.model?.users.filter{ $0.user == .watanabe }.first?.balance
            .map{ "\($0)" }
            .asDriver(onErrorJustReturn: "Rx binding error!")
            .drive(self.myview.balanceToLabel.rx.text)
            .disposed(by: self.disposeBag)

        if let model = model {
            self.myview.transferButton.rx.tap
                .asObservable()
                .flatMap{ return model.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount) }
                .subscribe()
                .disposed(by: self.disposeBag)

            self.myview.resetButton.rx.tap
                .asObservable()
                .subscribe(onNext: { _ in
                    model.reset()
                })
                .disposed(by: self.disposeBag)
        }
    }
}
