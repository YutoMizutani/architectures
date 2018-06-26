//
//  RS-ViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import ReSwift

class RSViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = RSState

    // ViewとDomainを保持する。
    var subview: View!
    var domain: PDSDomain!
}

extension RSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureState()
        layoutView()
        addAction()
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
extension RSViewController {
    /// Viewの構成を行う。
    private func configureView() {
        // Viewを作成する。
        self.subview = View()

        // Viewに表示されるラベルの名前を設定する。
        self.subview.toView.nameLabel.text = "\(UserList.takahashi.rawValue): "
        self.subview.fromView.nameLabel.text = "\(UserList.watanabe.rawValue): "

        // Viewに追加する。
        self.view.addSubview(self.subview)
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }

    /// Stateの構成を行う。
    private func configureState() {
        // 使用するUserの定義
        let users: [UserList] = [.takahashi, .watanabe]

        // UserLisetを元にDomainを作成する。
        self.domain = PDSDomain(users: users)


        // subscribe to state changes
        RSStore.subscribe(self)
    }

    /// ボタン押下時のアクションを設定する。
    private func addAction() {
        self.subview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
        self.subview.resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
    }
}

extension RSViewController: ErrorShowable {

    func newState(state: RSState) {
        // when the state changes, the UI is updated to reflect the current state

        if let error = state.error {
            self.showAlert(error: error)
        }

        var dictionary: Dictionary<String, Any> = Dictionary()
        dictionary[state.from.user.rawValue] = state.from.balance
        dictionary[state.to.user.rawValue] = state.to.balance
        self.update(dictionary)
    }

    // when either button is tapped, an action is dispatched to the store
    // in order to update the application state

    /// 送金を行う
    @IBAction func transfer() {
        RSStore.dispatch(RSActionTransfer())
    }

    /// リセットを行う
    @IBAction func reset() {
        RSStore.dispatch(RSActionReset())
    }

}

// MARK:- Private methods about userdefaults
extension RSViewController {
        /**
         UserDefaultsからデータを取得する。

         - returns:
         Dictionary型のユーザー情報
         */
        private func fetch() -> Dictionary<String, Any>? {
            let userDefaults: UserDefaults = UserDefaults.standard
            let key = UserDefaultsKeys.account.rawValue

            return userDefaults.dictionary(forKey: key)
        }


        /**
         UserDefaultsへデータを保存する。

         - Parameters:
         - dictionary: Dictionary型のユーザー情報
         */
        private func update(_ dictionary: Dictionary<String, Any>) {
            let userDefaults: UserDefaults = UserDefaults.standard
            let key = UserDefaultsKeys.account.rawValue

            userDefaults.set(dictionary, forKey: key)
        }
}
