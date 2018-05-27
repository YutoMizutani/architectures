//
//  CA-Presenter.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift

protocol CAPresenter: class {
    func fetch(_ models: [CAModel])
    func reset(_ models: [CAModel])
    func transfer(from: CAModel?, to: CAModel?, amount: Int)
}


class CAPresenterImpl {
    typealias viewInputType = CAViewInput
    typealias wireframeType = CAWireframe
    typealias useCaseType = CAUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: CAWireframe
    private let useCase: CAUseCase

    private let disposeBag = DisposeBag()

    init(
        viewInput: viewInputType,
        wireframe: wireframeType,
        useCase: useCaseType
        ) {
        self.viewInput = viewInput
        self.useCase = useCase
        self.wireframe = wireframe
    }
}

extension CAPresenterImpl: CAPresenter {
    /**
     更新を行う。

     - Parameters:
        - models: ユーザー情報
     */
    func fetch(_ models: [CAModel]) {
        let fetch = self.useCase.fetch(models).share()

        // Modelごとに更新を行う。
        for model in models {
            fetch.map{ $0.filter{ $0.user == model.user }.first }
                .filter{ $0 != nil }.map{ $0! }
                .subscribe(onNext: { [weak self] model in

                    // Modelを更新する。
                    self?.viewInput?.updateModel(model: model)

                }, onError: { [weak self] e in

                    // エラーを表示させる。
                    self?.viewInput?.presentAlert(e)

                })
                .disposed(by: disposeBag)
        }
    }

    /**
     初期化を行う。

     - Parameters:
        - models: ユーザー情報
     */
    func reset(_ models: [CAModel]) {
        // 初期化を行う。
        self.useCase.reset(models)
            .subscribe(onNext: { [weak self] _ in

                // 更新を行う。
                self?.fetch(models)

            }, onError: { [weak self] e in

                // エラーを表示させる。
                self?.viewInput?.presentAlert(e)

            })
            .disposed(by: disposeBag)
    }

    /**
     送金を行う。

     - Parameters:
         - from: 送金元のユーザー
         - to: 送金先のユーザー
         - amount: 金額
     */
    func transfer(from: CAModel?, to: CAModel?, amount: Int) {
        // fromのnilチェックを行う。
        guard let from = from else {
            self.viewInput?.presentAlert(ErrorTransfer.userNotFound)
            return
        }

        // toのnilチェックを行う。
        guard let to = to else {
            self.viewInput?.presentAlert(ErrorTransfer.userNotFound)
            return
        }

        // 送金処理を行う。
        self.useCase.transfer(from: from, to: to, amount: amount)
            .subscribe(onError: { [weak self] e in

                // エラーを表示させる。
                self?.viewInput?.presentAlert(e)

            })
            .disposed(by: disposeBag)
    }
}
