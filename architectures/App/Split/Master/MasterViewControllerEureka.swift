//
//  MasterViewControllerEureka.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import Eureka

extension MasterViewController {
    internal func configureEureka() {
        self.architecturesSection()
        self.endSection()
    }
}
// MARK:- Header and Footer
fileprivate struct CreateHeader {
    // 太字のヘッダーを作成。
    static func create(_ title: String) -> HeaderFooterView<UILabel> {
        let tableSectionHeaderViewHeightParameter:CGFloat = 50
        let tableBackgroundColor = UIColor.init(red: (0xef)/255.0, green: (0xef)/255.0, blue: (0xf4)/255.0, alpha: 1.0)

        var header = HeaderFooterView<UILabel>(.class)
        header.height = { tableSectionHeaderViewHeightParameter }
        header.onSetupView = {view, _ in
            view.backgroundColor = tableBackgroundColor
            view.frame.size.height = tableSectionHeaderViewHeightParameter
            view.textColor = UIColor.black
            let strBlank:String = "   " + title
            view.text = strBlank
            view.font = UIFont.boldSystemFont(ofSize: 25)
            view.baselineAdjustment = UIBaselineAdjustment.alignBaselines
        }

        return header
    }
}
fileprivate struct CreateFooter {
    // 高さ0のフッターを作成。
    static func create() -> HeaderFooterView<UIView> {
        var footer = HeaderFooterView<UIView>(.class)
        footer.height = { 0 }
        return footer
    }
}

// MARK:- Eureka tag Enum
private typealias EurekaTag = MasterViewControllerEurekaTags
enum MasterViewControllerEurekaTags: String, EnumCollection {
    case pp = "Procedural Programming"
    case fvc = "Fat ViewController"
    case mvc = "MVC"
    case mvp = "MVP"
    case mvvm = "MVVM"
    case ddd = "DDD"
    case fp = "Functional Programming"
    case cleanArchitecture = "Clean Architecture"
    case rvc = "Realistic ViewController"
}

extension MasterViewController {
    private func architecturesSection() {
        form
            +++ Section() { section in
                section.header = CreateFooter.create()
                section.footer = CreateFooter.create()

                for tag in EurekaTag.cases() {
                    section
                        <<< LabelRow(tag.rawValue) {
                            // Title
                            $0.title = $0.tag
                    }
                }
            }
    }

    fileprivate func endSection() {
        form
            // End blank
            +++ Section()
    }
}

