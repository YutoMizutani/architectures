//
//  CA-Presenter.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol CAPresenter: class {

}


class CAPresenterImpl {
    typealias viewInputType = CAViewInput
    typealias wireframeType = CAWireframe
    typealias useCaseType = CAUseCase

    private weak var viewInput: viewInputType?
    private let wireframe: CAWireframe
    private let useCase: CAUseCase

    init(
        viewInput: viewInputType,
        wireframe: wireframeType,
        useCase: useCaseType
        ) {
        self.viewInput = viewInput
        self.useCase = useCase
        self.wireframe = wireframe
    }
}

extension CAPresenterImpl: CAPresenter {
}
