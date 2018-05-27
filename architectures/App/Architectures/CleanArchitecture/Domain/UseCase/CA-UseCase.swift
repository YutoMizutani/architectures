//
//  CA-UseCase.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift

protocol CAUseCase {
    func fetch(_ models: [CAModel]) -> Observable<[CAModel]>
    func reset(_ models: [CAModel]) -> Observable<Void>

    func transfer(from: CAModel, to: CAModel, amount: Int) -> Observable<Void>
}

struct CAUseCaseImpl {
    typealias repositoryType = CARepository
    typealias translatorType = CATranslator

    private let repository: repositoryType
    private let translator: translatorType

    init(
        repository: repositoryType,
        translator: translatorType
        ) {
        self.repository = repository
        self.translator = translator
    }
}

// MARK:- Public methods accessed from other classes
extension CAUseCaseImpl: CAUseCase {
    /**
     残高を取得する。

     - Parameters:
        - model: ユーザー情報

     - returns:
        更新後のユーザー情報。
     */
    public func fetch(_ models: [CAModel]) -> Observable<[CAModel]> {
        return self.repository.fetch().map({ entities -> [CAModel] in
            var models: [CAModel] = []

            for entity in entities {
                if let model = try? self.translator.translate(from: entity) {
                    models.append(model)
                }
            }

            return models
        })
    }

    /**
     初期化を行う。

     - Parameters:
        - models: ユーザー情報

     - returns:
        処理の完了を伝える。
     */
    public func reset(_ models: [CAModel]) -> Observable<Void> {
        for model in models {
            model.balance.accept(model.user.initValue)
        }

        let collections = models.map{ self.translator.translate(from: $0) }

        return self.repository.commit(collections)
    }


    /**
     送金を行う。

     - Parameters:
         - from: 送金元のユーザー
         - to: 送金先のユーザー
         - amount: 金額

     - returns:
        処理の完了を伝える。
     */
    public func transfer(from: CAModel, to: CAModel, amount: Int) -> Observable<Void> {
        // エラーがなければflatMapで処理を続ける。
        return self.checkAmountOverflow(to, amount: amount)
            .flatMap{ self.checkInsufficientFunds(from, amount: amount) }
            .flatMap{ self.credit(to, amount: amount) }
            .flatMap{ self.debit(from, amount: amount) }
            .flatMap{
                // 更新を行う。
                self.repository.commit(
                    [from, to].map{ self.translator.translate(from: $0) }
                )
            }
    }
}

extension CAUseCaseImpl {
    /**
     取引後に残高超過に陥るかを判断する。

     - Parameters:
         - user: 対象ユーザー
         - amount: 金額

     - Returns:
        Bool (上回る場合，true)
     */
    private func checkAmountOverflow(_ model: CAModel, amount: Int) -> Observable<Void> {
        return Observable.create({ observer in
            // 入金後の残高がIntの最大値を超過するかの判断を行う
            if model.balance.value > Int.max - amount {
                observer.onError(ErrorTransfer.amountOverflow)
            }

            // 処理の完了後に流す。
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }

    /**
     取引後に残高不足に陥るかを判断する。

     - Parameters:
         - user: 対象ユーザー
         - amount: 金額

     - Returns:
        Bool (下回る場合，true)
     */
    private func checkInsufficientFunds(_ model: CAModel, amount: Int) -> Observable<Void> {
        return Observable.create({ observer in
            // 出金後の残高が0を下回るかの判断を行う
            if model.balance.value - amount < 0 {
                observer.onError(ErrorTransfer.insufficientFunds)
            }

            // 処理の完了後に流す。
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }

    /**
     入金処理を行う

     - Parameters:
        - amount: 金額

     - throws:
        Intの最大値を超過する場合
     */
    private func credit(_ model: CAModel, amount: Int) -> Observable<Void> {
        return Observable.create({ observer in
            // 金額を加算する。
            model.balance.accept(model.balance.value + amount)

            // 処理の完了後に流す。
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }

    /**
     出金処理を行う

     - Parameters:
        - amount: 金額

     - throws:
        0未満になる場合
     */
    private func debit(_ model: CAModel, amount: Int) -> Observable<Void> {
        return Observable.create({ observer in
            // 金額を減算する。
            model.balance.accept(model.balance.value - amount)

            // 処理の完了後に流す。
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }
}
