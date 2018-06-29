//
//  RK-Reactor.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import ReactorKit
import RxSwift

final class RKReactor: Reactor {
    // Action is an user interaction
    enum Action {
        case transfer
        case reset
        case fetch
    }

    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case transferValue
        case resetValue
        case fetchValue
        case updateValue
    }

    // State is a current view state
    struct RKState {
        var to: (user: UserList, balance: Int)?
        var from: (user: UserList, balance: Int)?
        var error: Error?
    }

    let initialState: RKState

    init(_ users: (to: UserList, from: UserList)) {
        self.initialState = RKState(
            to: (user: users.to, balance: users.to.initValue),
            from: (user: users.from, balance: users.from.initValue),
            error: nil
        )
    }

    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .transfer:
            return Observable.concat([
                Observable.just(Mutation.transferValue),
                Observable.just(Mutation.updateValue),
                ])

        case .reset:
            return Observable.concat([
                Observable.just(Mutation.resetValue),
                Observable.just(Mutation.updateValue),
                ])

        case .fetch:
            return Observable.concat([
                Observable.just(Mutation.fetchValue),
                Observable.just(Mutation.updateValue),
                ])
        }
    }

    // Mutation -> State
    func reduce(state: RKState, mutation: Mutation) -> RKState {
        var state = state

        // エラーはViewControllerで都度処理されるため，Reducerが走る度に初期化する。
        state.error = nil

        if state.from == nil || state.to == nil {
            state.error = ErrorTransfer.userNotFound
            return state
        }

        switch mutation {
        case .transferValue:
            return transfer(&state)
        case .resetValue:
            return reset(&state)
        case .fetchValue:
            return fetch(state)
        case .updateValue:
            update(state)
            return state
        }
    }
}

extension RKReactor {
    /// 更新を反映する
    private func fetch(_ state: RKState) -> RKState {
        guard state.to != nil else { return state }
        guard state.from != nil else { return state }
        guard state.error == nil else { return state }
        guard let dictionary = self.fetchDictionary() else { return state }

        let fromValue = ((dictionary[state.from!.user.rawValue] as? Int) ?? state.from?.balance) ?? state.from!.user.initValue
        let toValue = ((dictionary[state.to!.user.rawValue] as? Int) ?? state.to?.balance) ?? state.to!.user.initValue

        return RKState(
            to: (user: state.to!.user, balance: toValue),
            from: (user: state.from!.user, balance: fromValue),
            error: nil
        )
    }

    /// 送金を行う
    private func transfer(_ state: inout RKState) -> RKState {
        guard state.to != nil else { return state }
        guard state.from != nil else { return state }
        guard state.error == nil else { return state }

        let amount: Int = Assets.amount

        // 入金後の残高がIntの最大値を超過するかの判断を行う
        if state.to!.balance > Int.max - amount {
            state.error = ErrorTransfer.amountOverflow
            return state
        }
        // 出金後の残高が0を下回るかの判断を行う
        if state.from!.balance - amount < 0 {
            state.error = ErrorTransfer.insufficientFunds
            return state
        }

        // 送金処理
        state.from!.balance -= amount
        state.to!.balance += amount

        return state
    }

    /// リセットを行う
    private func reset(_ state: inout RKState) -> RKState {
        guard state.to != nil else { return state }
        guard state.from != nil else { return state }
        guard state.error == nil else { return state }

        // UserListに登録された情報を元に初期化する。
        state.to!.balance = state.to!.user.initValue
        state.from!.balance = state.from!.user.initValue

        return state
    }

    /// 更新を行う
    private func update(_ state: RKState) {
        guard state.to != nil else { return }
        guard state.from != nil else { return }
        guard state.error == nil else { return }

        var dictionary: Dictionary<String, Any> = self.fetchDictionary() ?? Dictionary()
        dictionary[state.from!.user.rawValue] = state.from!.balance
        dictionary[state.to!.user.rawValue] = state.to!.balance
        self.updateDictionary(dictionary)
    }
}

// MARK:- Private methods about userdefaults
extension RKReactor {
    /**
     UserDefaultsからデータを取得する。

     - returns:
     Dictionary型のユーザー情報
     */
    private func fetchDictionary() -> Dictionary<String, Any>? {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        return userDefaults.dictionary(forKey: key)
    }

    /**
     UserDefaultsへデータを保存する。

     - Parameters:
     - dictionary: Dictionary型のユーザー情報
     */
    private func updateDictionary(_ dictionary: Dictionary<String, Any>) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let key = UserDefaultsKeys.account.rawValue

        userDefaults.set(dictionary, forKey: key)
    }
}
