//
//  MasterViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Eureka

class MasterViewController: FormViewController {
    let disposeBag = DisposeBag()
}

extension MasterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureEureka()
        layoutView()
        binding()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutView()

        self.view.layoutIfNeeded()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        layoutView()
    }
}

extension MasterViewController {
    private func configureView() {
    }
    private func layoutView() {
    }
    private func binding() {
        tableView: do {
            self.tableView.rx.itemSelected
                .subscribe(onNext: { [weak self] indexPath in
                    self?.select(indexPath)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension MasterViewController {
    private func select(_ indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            // PDS
            case 0:
                let nextViewController = PDSBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.pds.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // MVC
            case 1:
                let nextViewController = MVCBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvc.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // MVP
            case 2:
                let nextViewController = MVPBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvp.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // MVVM
            case 3:
                let nextViewController = MVVMBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvvm.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // DDD
            case 4:
                let nextViewController = RFBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.rf.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // RxFeedback
            case 5:
                let nextViewController = DDDBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.ddd.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // Clean Architecture
            case 6:
                let nextViewController = CABuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.ca.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // RVC
            case 7:
                let nextViewController = RVCBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.rvc.short
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
}
