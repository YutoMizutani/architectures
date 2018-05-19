//
//  SplitViewControlelr.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    init(masterNavigationController: UINavigationController, detailNavigationController: UINavigationController) {

        super.init(nibName: nil, bundle: nil)

        do {
            // SplitViewControllerの要素にMasterViewControllerを指定する。
            self.viewControllers = [masterNavigationController]

            // iPadは画面が広く，MasterVCが全面を覆うことはなく，DetailVCも表示される。\
            // iPadの場合，最初に表示するVCを追加する。
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.viewControllers.append(detailNavigationController)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layoutView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutView()

        self.view.layoutIfNeeded()
    }
    
}

extension SplitViewController {
    private func configureView() {
        splitView: do {
            self.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        }
    }
    private func layoutView() {
    }
}

extension SplitViewController {
    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        return UISplitViewControllerDisplayMode.allVisible
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        super.willTransition(to: newCollection, with: coordinator)
    }
    // 起動時master view
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}
