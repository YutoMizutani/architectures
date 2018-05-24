//
//  TestViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TBuilder {
    func build() -> UIViewController {
        return TViewController()
    }
}

class TViewController: UIViewController {
    var myview: View = View()

    let firstValue: (a: Int, b: Int) = (0, 1000)

    var aBalance: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var bBalance: BehaviorRelay<Int> = BehaviorRelay(value: 0)

    let disposeBag = DisposeBag()
}

extension TViewController {
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

extension TViewController {
    private func configureView() {
        self.view.addSubview(self.myview)
    }

    private func layoutView() {
        self.myview.frame = self.view.frame
    }

    private func binding() {
        self.aBalance
            .asObservable()
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(self.myview.toView.valueLabel.rx.text)
            .disposed(by: disposeBag)

        self.bBalance
            .asObservable()
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(self.myview.fromView.valueLabel.rx.text)
            .disposed(by: disposeBag)

//        self.myview.transferButton.rx.tap
//            .asObservable()
//            .subscribe(onNext: { [weak self] _ in
//                self?.transfer()
//            })
//            .disposed(by: disposeBag)
//
//        self.myview.resetButton.rx.tap
//            .asObservable()
//            .subscribe(onNext: { [weak self] _ in
//                self?.reset()
//            })
//            .disposed(by: disposeBag)


        self.myview.transferButton.rx.tap
            .asObservable()
            .subscribe(onNext: {
                self.completed()
            })
            .disposed(by: disposeBag)

        self.myview.resetButton.rx.tap
            .asObservable()
            .subscribe(onNext: {
                self.next()
            })
            .disposed(by: disposeBag)
    }
}

extension TViewController: ErrorShowable {
    /// aからbに送金を行う
    private func transfer() {
        if self.bBalance.value - 100 < 0 {
            self.showAlert(error: ErrorTransfer.insufficientFunds)
            return
        }

        self.aBalance.accept(self.aBalance.value + 100)
        self.bBalance.accept(self.bBalance.value - 100)
    }

    /// a，bを初期化する
    private func reset() {
        self.aBalance.accept(firstValue.a)
        self.bBalance.accept(firstValue.b)
    }
}

extension TViewController {
    private func observableNext() -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            print("observable()")
            observer.onNext()

            return Disposables.create()
        })
    }

    private func observableNextCompleted() -> Observable<Void> {
        return Observable.create({ observer -> Disposable in
            print("observableNextCompleted()")
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }

    private func next() {
        Observable<Void>.create({ observer -> Disposable in
            print("observable()")
            observer.onNext()

            return Disposables.create()
        })
        .asObservable()
        .subscribe(onNext: {
            print("next - onNext")
        }, onCompleted: {
            print("next - onCompleted")
        })
        .disposed(by: disposeBag)
    }

    private func completed() {
        Observable<Void>.create({ observer -> Disposable in
            print("observableNextCompleted()")
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
        .asObservable()
        .subscribe(onNext: {
            print("completed - onNext")
        }, onCompleted: {
            print("completed - onCompleted")
        })
        .disposed(by: disposeBag)
    }
}
