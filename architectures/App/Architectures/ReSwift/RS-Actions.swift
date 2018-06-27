//
//  RS-Actions.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import ReSwift

// all of the actions that can be applied to the state
typealias RSAction = Action
struct RSActionTransfer: RSAction {}
struct RSActionReset: RSAction {}
