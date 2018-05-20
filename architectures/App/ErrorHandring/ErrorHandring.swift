//
//  ErrorHandring.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/20.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIAlertController {
    private static func present(_ delegate: UIViewController, message: String, actionTitle: String = "Cancel") {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel) { _ -> Void in
        })

        DispatchQueue.main.async {
            delegate.present(alert, animated: true, completion: nil)
        }
    }

    static func present(_ delegate: UIViewController, error: Error) {
        guard let error = error as? ErrorTransfer else {
            UIAlertController.present(delegate, message: "未定義のエラーが発生しました", actionTitle: "OK")
            return
        }

        switch error {
        case .userNotFound:
            UIAlertController.present(delegate, message: "登録されていない口座情報です")
            return
        case .storedTypeInvalid:
            UIAlertController.present(delegate, message: "保存データの型が不適切です")
            return
        case .amountOverflow:
            UIAlertController.present(delegate, message: "取引後の残高上限が超過します")
            return
        case .insufficientFunds:
            UIAlertController.present(delegate, message: "残高が不足しています")
            return
        case .transactionLocking:
            UIAlertController.present(delegate, message: "他の取引が実行中です")
            return
        case .updateFailed:
            UIAlertController.present(delegate, message: "口座情報の更新に失敗しました。取引を中止します", actionTitle: "OK")
            return
        }
    }
}
