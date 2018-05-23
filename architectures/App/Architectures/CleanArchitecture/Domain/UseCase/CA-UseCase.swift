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

extension CAUseCaseImpl: CAUseCase {
    func fetch(_ models: [CAModel]) -> Observable<[CAModel]> {
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

    func reset(_ models: [CAModel]) -> Observable<Void> {
        let collections = models.map{ self.translator.translate(from: $0) }

        return self.repository.commit(collections)
    }

    func transfer(from: CAModel, to: CAModel, amount: Int) -> Observable<Void> {
        return self.credit(to, amount: amount)
            .flatMap{ self.debit(from, amount: amount)}
            .flatMap{
                self.repository.commit(
                    [from, to].map{ self.translator.translate(from: $0) }
                )
            }
    }
}

extension CAUseCaseImpl {
    /**
     入金処理を行う

     - Parameters:
     - amount: 金額(Int)

     - throws: Intの最大値を超過する場合
     */
    private func credit(_ model: CAModel, amount: Int) -> Observable<Void> {
        return Observable.create({ observer in
            // 入金後の残高がIntの最大値を超過するかの判断を行う
            if model.balance.value > Int.max - amount {
                observer.onError(ErrorTransfer.amountOverflow)
            }

            // 金額を加算する
            model.balance.accept(model.balance.value + amount)
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }

    /**
     出金処理を行う

     - Parameters:
     - amount: 金額(Int)

     - throws: Intの最大値を超過する場合
     */
    private func debit(_ model: CAModel, amount: Int) -> Observable<Void> {
        return Observable.create({ observer in
            // 出金後の残高が0を下回かの判断を行う
            if model.balance.value - amount > 0 {
                observer.onError(ErrorTransfer.insufficientFunds)
            }

            // 金額を加算する
            model.balance.accept(model.balance.value - amount)
            observer.onNext()
            observer.onCompleted()

            return Disposables.create()
        })
    }
}
