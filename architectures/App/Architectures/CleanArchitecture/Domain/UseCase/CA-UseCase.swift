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
    func fetch() -> Observable<[CAModel]>
    func reset() -> Observable<Void>

    func begin() -> Observable<Void>
    func end() -> Observable<Void>

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
    func fetch() -> Observable<[CAModel]> {
        return self.repository.fetch().map({ entities -> [CAModel] in
            var models: [CAModel] = []

            for entity in entities {
                let model = self.translator.translate(from: entity)
                models.append(model)
            }

            return models
        })
    }

    func reset() -> Observable<Void> {
        let a = CAModelImpl(name: UserList.a.rawValue, balance: 0)
        let b = CAModelImpl(name: UserList.b.rawValue, balance: 1000)

        let collections = [a, b].map{ self.translator.translate(from: $0) }

        return self.repository.beginLocking()
            .concat(self.repository.commit(collections))
            .concat(self.repository.endLocking())
    }

    func transfer(from: CAModel, to: CAModel, amount: Int) -> Observable<Void> {
        return self.repository.beginLocking()
            .concat(self.credit(from, amount: amount))
            .concat(self.debit(from, amount: amount))
            .concat(self.debit(from, amount: amount))
            .concat(
                self.repository.commit(
                    [from, to].map{ self.translator.translate(from: $0) }
                    )
            )
            .concat(self.repository.endLocking())
    }
    
    func begin() -> Observable<Void> {
        return self.repository.beginLocking()
    }

    func end() -> Observable<Void> {
        return self.repository.endLocking()
    }
}

extension CAUseCaseImpl {
    func getInitModel() -> Observable<[CAModel]> {
        return Observable.create({ observer -> Disposable in
            let a = CAModelImpl(name: UserList.a.rawValue, balance: 0)
            let b = CAModelImpl(name: UserList.b.rawValue, balance: 1000)
            observer.onNext([a, b])
            observer.onCompleted()

            return Disposables.create()
        })
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
