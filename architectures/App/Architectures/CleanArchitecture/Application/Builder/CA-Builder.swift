//
//  CA-Builder.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

struct CABuilder {
    func build() -> UIViewController {
        let viewController = CAViewController()
        viewController.inject(
            presenter: CAPresenterImpl(
                viewInput: viewController,
                wireframe: CAWireframeImpl(
                    viewController: viewController
                ),
                useCase: CAUseCaseImpl(
                    repository: CARepositoryImpl (
                        dataStore: CADataStoreImpl()
                    ),
                    translator: CATranslatorImpl()
                )
            )
        )
        return viewController
    }
}
