//
//  ErrorHandring.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/20.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

fileprivate extension UIAlertController {
    static func present(_ delegate: UIViewController, message: String, actionTitle: String = "Cancel") {
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
}

protocol ErrorShowable where Self: UIViewController {
    func showAlert(error: Error)
}

extension ErrorShowable {
    func showAlert(error: Error) {
        guard let error = error as? ErrorTransfer else {
            UIAlertController.present(self, message: "未定義のエラーが発生しました", actionTitle: "OK")
            return
        }

        switch error {
        case .noContent:
            UIAlertController.present(self, message: "取引履歴が存在しません")
            return
        case .userNotFound:
            UIAlertController.present(self, message: "登録されていない口座情報です")
            return
        case .storedTypeInvalid:
            UIAlertController.present(self, message: "保存データの型が不適切です")
            return
        case .amountOverflow:
            UIAlertController.present(self, message: "取引後の残高上限が超過します")
            return
        case .insufficientFunds:
            UIAlertController.present(self, message: "残高が不足しています")
            return
        case .updateFailed:
            UIAlertController.present(self, message: "口座情報の更新に失敗しました。取引を中止します", actionTitle: "OK")
            return
        }
    }
}
