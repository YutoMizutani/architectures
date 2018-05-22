//
//  Error.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/20.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum ErrorTransfer: Error {
    // 口座履歴が存在しない場合
    case noContent

    // 用意されていない口座情報を取得しようとした場合
    case userNotFound

    // 取り出した保存データの型が異なっていた場合
    case storedTypeInvalid

    // 残高の上限を超過した場合
    case amountOverflow

    // 残高が不足した場合
    case insufficientFunds

    // 取引にロックがかかっていた(他の取引中に実行しようとした)場合
    case transactionLocking

    // 口座情報の更新が失敗した場合
    case updateFailed
}
