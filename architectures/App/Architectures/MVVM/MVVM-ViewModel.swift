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
    var model: MVVMModel = MVVMModel()

    let disposeBag = DisposeBag()
}

extension MVVMViewModel {
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

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        layoutView()
    }
}

extension MVVMViewModel {
    private func configureView() {
        self.view.addSubview(self.myview)
    }

    private func layoutView() {
        self.myview.frame = self.view.frame
    }
    
    private func binding() {
        count: do {
//            self.model.count
//                .map { "\($0)" }
//                .asDriver(onErrorJustReturn: "Rx binding error!")
//                .drive(self.myview.displayLabel.rx.text)
//                .disposed(by: self.disposeBag)
//
//            self.myview.countButton.rx.tap
//                .asObservable()
//                .subscribe(onNext: { [weak self] _ in
//                    self?.model.countUp()
//                })
//                .disposed(by: self.disposeBag)

            self.myview.resetButton.rx.tap
                .asObservable()
                .subscribe(onNext: { [weak self] _ in
                    self?.model.resetCount()
                })
                .disposed(by: self.disposeBag)
        }
    }
}
