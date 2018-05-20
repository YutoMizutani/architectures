//
//  CA-Model.swift
//  architectures
//
//  Created by Yuto Mizutani on 2018/5/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol CAModel {
   var id: Int { get }
}


struct CAModelImpl: CAModel {
    let id: Int
}
