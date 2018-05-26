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
    // ViewとModelを保持する。
    var subview: MVVMView!
    var model: MVVMModel!

    /// Rx bindingを解除するためのDisposeBag。
    let disposeBag = DisposeBag()
}

// MARK:- Override methods
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

// MARK:- Private methods about settings
extension MVVMViewModel: ErrorShowable {
    /// Viewの構成を行う。
    private func configureView() {
        // Viewを作成する。
        self.subview = MVVMView()

        // Viewに表示されるラベルの名前を設定する。
        self.subview.toView.nameLabel.text = "\(UserList.takahashi.rawValue): "
        self.subview.fromView.nameLabel.text = "\(UserList.watanabe.rawValue): "

        // Viewに追加する。
        self.view.addSubview(self.subview)
    }

    /// Modelの構成を行う。
    private func configureModel() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // UserLisetを元にModelを作成する。
        self.model = MVVMModel(users: users)

        // Model要素を更新する。
        self.model?.fetch()
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }

    /// View要素とBusiness logicのバインディングを行う。
    private func binding() {
        // Takahashiさんの残高をラベルにバインドする。
        self.model?.users.filter{ $0.user == .takahashi }.first?.balance
            .map{ "\($0)" }
            .asDriver(onErrorJustReturn: "Rx binding error!")
            .drive(self.subview.toView.valueLabel.rx.text)
            .disposed(by: self.disposeBag)

        // Watanabeさんの残高をラベルにバインドする。
        self.model?.users.filter{ $0.user == .watanabe }.first?.balance
            .map{ "\($0)" }
            .asDriver(onErrorJustReturn: "Rx binding error!")
            .drive(self.subview.fromView.valueLabel.rx.text)
            .disposed(by: self.disposeBag)

        // 送金処理をボタンにバインドする。
        // この時，onErrorが発生するとRxの購読が解除されてしまうため，onError発生時に再帰的に再購読を行う。
        func bindingErrorable() {
            self.subview.transferButton.rx.tap
                .asObservable()
                // WatanabeさんからTakahashiさんに送金を行う。
                .flatMap{ self.model.transfer(from: .watanabe, to: .takahashi, amount: Assets.amount) }
                .subscribe(onError: { [weak self] e in

                    // アラートを表示する。
                    self?.showAlert(error: e)

                    // 再帰的に再購読を行う。
                    bindingErrorable()

                })
                .disposed(by: self.disposeBag)
        }
        bindingErrorable()

        // 残高のリセット処理をボタンにバインドする。
        self.subview.resetButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in

                // 残高のリセットを行う。
                self?.model.reset()

            })
            .disposed(by: self.disposeBag)
    }
}
