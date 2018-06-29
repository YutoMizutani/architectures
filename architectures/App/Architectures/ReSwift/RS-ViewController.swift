//
//  RS-ViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import ReSwift

class RSViewController: UIViewController {
    typealias StoreSubscriberStateType = RSState

    // ViewとStoreを保持する。
    var subview: View!
    let store = Store<RSState>(
        reducer: transferReducer,
        state: nil
    )
}

extension RSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureStore()
        layoutView()
        addAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 残高を取得する。
        fetch()
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
    /// Stateの構成を行う。
    private func configureStore() {
        // 使用するUserの定義
        let users: (to: UserList, from: UserList) = (.takahashi, .watanabe)

        self.store.state = RSState(
            to: (user: users.to, balance: users.to.initValue),
            from: (user: users.from, balance: users.from.initValue),
            error: nil
        )
        self.fetch()

        // subscribe to state changes
        self.store.subscribe(self)
    }

    /// Viewの構成を行う。
    private func configureView() {
        // Viewを作成する。
        self.subview = View()

        // Viewに追加する。
        self.view.addSubview(self.subview)
    }

    /// Viewの更新を行う。
    private func layoutView() {
        // subviewのサイズを更新する。
        self.subview.frame = self.view.frame
    }

    /// ボタン押下時のアクションを設定する。
    private func addAction() {
        self.subview.transferButton.addTarget(self, action: #selector(self.transfer), for: .touchUpInside)
        self.subview.resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
    }
}

extension RSViewController {
    /// 送金を行う
    @IBAction private func transfer() {
        self.store.dispatch(RSActionTransfer())
    }

    /// リセットを行う
    @IBAction private func reset() {
        self.store.dispatch(RSActionReset())
    }
}

extension RSViewController: StoreSubscriber, ErrorShowable {
    /// when the state changes, the UI is updated to reflect the current state
    func newState(state: RSState) {
        if let error = state.error {
            self.showAlert(error: error)
            return
        }

        self.updateView(state)
        self.update(state)
    }
}

extension RSViewController {
    /// Viewの更新を行う。
    private func updateView(_ state: RSState) {
        DispatchQueue.main.async {
            // Viewに表示されるラベルの名前を設定する。
            self.subview.toView.nameLabel.text = "\(state.to?.user.rawValue ?? ""): "
            self.subview.fromView.nameLabel.text = "\(state.from?.user.rawValue ?? ""): "

            // Viewに表示されるラベルの残高を設定する。
            self.subview.fromView.valueLabel.text = "\(state.from?.balance ?? 0)"
            self.subview.toView.valueLabel.text = "\(state.to?.balance ?? 0)"
        }
    }
}

extension RSViewController {
    private func fetch() {
        if let dictionary = self.fetchDictionary() {
            self.store.state.from?.balance = (dictionary[self.store.state.from!.user.rawValue] as? Int) ?? self.store.state.from!.user.initValue
            self.store.state.to?.balance = (dictionary[self.store.state.to!.user.rawValue] as? Int) ?? self.store.state.to!.user.initValue
        }
    }

    private func update(_ state: RSState) {
        var dictionary: Dictionary<String, Any> = self.fetchDictionary() ?? Dictionary()
        dictionary[state.from!.user.rawValue] = state.from!.balance
        dictionary[state.to!.user.rawValue] = state.to!.balance
        self.updateDictionary(dictionary)
    }
}

// MARK:- Private methods about userdefaults
fileprivate extension UIViewController {
    /**
     UserDefaultsからデータを取得する。

     - returns:
     Dictionary型のユーザー情報
     */
    func fetchDictionary() -> Dictionary<String, Any>? {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        return userDefaults.dictionary(forKey: key)
    }


    /**
     UserDefaultsへデータを保存する。

     - Parameters:
     - dictionary: Dictionary型のユーザー情報
     */
    func updateDictionary(_ dictionary: Dictionary<String, Any>) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        userDefaults.set(dictionary, forKey: key)
    }
}
