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
    func fetch()
    func reset()
    func transfer(from: CAModel?, to: CAModel?, amount: Int)

    func begin()
    func end()
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
    func fetch() {
        let fetch = self.useCase.fetch().asObservable().share()

        fetch.map{ $0.filter{ $0.name == UserList.a.rawValue }.first }
            .filter{ $0 != nil }.map{ $0! }
            .subscribe(onNext: { [weak self] model in
                print("onNext")
                self?.viewInput?.setModel(.a, model: model)
            }, onError: { [weak self] e in
                print("onError")
                self?.viewInput?.presentAlert(e)
            })
            .disposed(by: disposeBag)

        fetch.map{ $0.filter{ $0.name == UserList.b.rawValue }.first }
            .filter{ $0 != nil }.map{ $0! }
            .subscribe(onNext: { [weak self] model in
                print("onNext")
                self?.viewInput?.setModel(.b, model: model)
            }, onError: { [weak self] e in
                print("onError")
                self?.viewInput?.presentAlert(e)
            })
            .disposed(by: disposeBag)
    }

    func reset() {
        self.useCase.reset().asObservable()
            .subscribe(onNext: { [weak self] _ in
                print("onNext")
                self?.fetch()
            }, onError: { [weak self] e in
                print("onError")
                self?.viewInput?.presentAlert(e)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
            .disposed(by: disposeBag)
    }

    func transfer(from: CAModel?, to: CAModel?, amount: Int) {
        guard let from = from else {
            self.viewInput?.presentAlert(ErrorTransfer.userNotFound)
            return
        }
        guard let to = to else {
            self.viewInput?.presentAlert(ErrorTransfer.userNotFound)
            return
        }
        self.useCase.transfer(from: from, to: to, amount: amount)
            .asObservable()
            .subscribe(onError: { [weak self] e in
                self?.viewInput?.presentAlert(e)
            })
            .disposed(by: disposeBag)
    }

    func begin() {
        self.useCase.begin()
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                print("onNext")
            }, onError: { [weak self] e in
                print("onError")
                self?.viewInput?.presentAlert(e)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
            .disposed(by: disposeBag)
    }

    func end() {
        self.useCase.end()
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                print("onNext")
            }, onError: { [weak self] e in
                print("onError")
                self?.viewInput?.presentAlert(e)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
            .disposed(by: disposeBag)
    }
}
