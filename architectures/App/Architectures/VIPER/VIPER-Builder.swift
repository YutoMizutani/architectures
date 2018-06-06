//
//  VIPER-Builder.swift
//  architectures
//
//  Created by YutoMizutani on 2018/06/06.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class VIPERBuilder {
    func build() -> UIViewController {
        return VIPERRouter.createModule()
    }
}
