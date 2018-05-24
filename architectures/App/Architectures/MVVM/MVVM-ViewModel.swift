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
    var subview: MVVMView = MVVMView()
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

extension MVVMViewModel: ErrorShowable {
    private func configureView() {
        self.subview.toView.nameLabel.text = "\(UserList.takahashi.rawValue): "
        self.subview.fromView.nameLabel.text = "\(UserList.watanabe.rawValue): "
        self.view.addSubview(self.subview)
    }

    private func configureModel() {
        let users: [UserList] = [.takahashi, .watanabe]
        self.model = MVVMModel.init(users: users)
        self.model?.fetch()
    }

    private func layoutView() {
        self.subview.frame = self.view.frame
    }
    
    private func binding() {
        self.model?.users.filter{ $0.user == .takahashi }.first?.balance
            .map{ "\($0)" }
            .asDriver(onErrorJustReturn: "Rx binding error!")
            .drive(self.subview.toView.valueLabel.rx.text)
            .disposed(by: self.disposeBag)

        self.model?.users.filter{ $0.user == .watanabe }.first?.balance
            .map{ "\($0)" }
            .asDriver(onErrorJustReturn: "Rx binding error!")
            .drive(self.subview.fromView.valueLabel.rx.text)
            .disposed(by: self.disposeBag)

        if let model = model {
            func bindingErrorable() {
                self.subview.transferButton.rx.tap
                    .asObservable()
                    .flatMap{ model.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount) }
                    .subscribe(onError: { [unowned self] e in
                        self.showAlert(error: e)
                        bindingErrorable()
                    })
                    .disposed(by: self.disposeBag)
            }
            bindingErrorable()

            self.subview.resetButton.rx.tap
                .asObservable()
                .subscribe(onNext: { _ in
                    model.reset()
                })
                .disposed(by: self.disposeBag)
        }
    }
}
