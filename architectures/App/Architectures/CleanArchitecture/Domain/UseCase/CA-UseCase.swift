//
//  CA-UseCase.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol CAUseCase {
    func fetch(_ closure: (CAModel) -> Void) throws
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
    func fetch(_ closure: (CAModel) -> Void) throws  {
        try repository.fetch {
           closure(
              translator.translate(from: $0)
           )
        }
    }
}
