//
//  RS-Store.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import ReSwift

// The global application store, which is responsible for managing the appliction state.
let RSStore = Store<RSState>(
    reducer: transferReducer,
    state: nil
)
