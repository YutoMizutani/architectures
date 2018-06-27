//
//  RS-Reducer.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import ReSwift

// the reducer is responsible for evolving the application state based
// on the actions it receives
func transferReducer(action: RSAction, state: RSState?) -> RSState {
    // if no state has been provided, create the default state
    var state = state ?? RSState.empty

    // エラーはViewControllerで都度処理されるため，Reducerが走る度に初期化する。
    state.error = nil

    if state.from != nil && state.to != nil {
        state.error = ErrorTransfer.userNotFound
        return state
    }

    switch action {
    case _ as RSActionTransfer:
        return transfer(&state)
    case _ as RSActionReset:
        return reset(&state)
    default:
        break
    }

    return state
}

fileprivate func transfer(_ state: inout RSState) -> RSState {
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

    state.from!.balance -= amount
    state.to!.balance += amount

    return state
}

fileprivate func reset(_ state: inout RSState) -> RSState {
    state.to!.balance = state.to!.user.initValue
    state.from!.balance = state.from!.user.initValue

    return state
}
