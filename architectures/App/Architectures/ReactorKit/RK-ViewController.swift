//
//  RK-ViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

class RKViewController: UIViewController {
    typealias Reactor = RKReactor
    var disposeBag = DisposeBag()

    // Viewを保持する。
    private var subview: View!

    private let subject: BehaviorSubject<Void> = BehaviorSubject(value: ())
}

extension RKViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureReactor()
        layoutView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 残高を取得する。
        _ = self.subject.do()
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
extension RKViewController {
    /// Viewの構成を行う。
    private func configureView() {
        // Viewを作成する。
        self.subview = View()

        // Viewに追加する。
        self.view.addSubview(self.subview)
    }

    /// Conform to the protocol `View` then the property `self.reactor` will be available.
    private func configureReactor() {
        // 使用するUserの定義
        let users: (to: UserList, from: UserList) = (.takahashi, .watanabe)
        self.reactor = RKReactor(users)
        
        // 残高を取得する。
        _ = self.subject.do()
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }
}

extension RKViewController: StoryboardView, ErrorShowable {
    // Called when the new value is assigned to `self.reactor`
    func bind(reactor: RKReactor) {
        // Action
        self.subview.transferButton.rx.tap
            .map { Reactor.Action.transfer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.subview.resetButton.rx.tap
            .map { Reactor.Action.reset }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.subject
            .map { Reactor.Action.fetch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state.map { $0.from?.user.rawValue }
            .filter { $0 != nil }.map { $0! }
            .distinctUntilChanged()
            .bind(to: self.subview.fromView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.from?.balance }
            .filter { $0 != nil }.map { $0! }
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: self.subview.fromView.valueLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.to?.user.rawValue }
            .filter { $0 != nil }.map { $0! }
            .distinctUntilChanged()
            .bind(to: self.subview.toView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state.map { $0.to?.balance }
            .filter { $0 != nil }.map { $0! }
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: self.subview.toView.valueLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.error }
            .filter { $0 != nil }.map { $0! }
            .asObservable()
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(error: error)
            })
            .disposed(by: disposeBag)
    }
}
