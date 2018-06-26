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
    var state = state ?? RSState()

    switch action {
    case _ as RSActionTransfer:
        let amount: Int = Assets.amount

        // 入金後の残高がIntの最大値を超過するかの判断を行う
        if state.to > Int.max - amount {
            state.error = ErrorTransfer.amountOverflow
            break
        }
        // 出金後の残高が0を下回るかの判断を行う
        if state.from - amount < 0 {
            state.error = ErrorTransfer.insufficientFunds
            break
        }

        state.from -= amount
        state.to += amount
        break
    case _ as RSActionReset:
        state.to = UserList.watanabe.initValue
        state.from = UserList.takahashi.initValue
        break
    default:
        break
    }

    return state
}
