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
            // Procedural Programming
            case 0:
                break
            // Fat ViewController
            case 1:
                break
            // MVC
            case 2:
                let nextViewController = MVCBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvc.rawValue
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // MVP
            case 3:
                let nextViewController = MVPBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvp.rawValue
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // MVVM
            case 4:
                let nextViewController = MVVMBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvvm.rawValue
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // DDD
            case 5:
                let nextViewController = DDDBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.ddd.rawValue
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // FP
            case 6:
                break
            // Clean Architecture
            case 7:
                let nextViewController = CABuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.cleanArchitecture.rawValue
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            // RVC
            case 8:
                let nextViewController = RVCBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.rvc.rawValue
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            default:
                let nextViewController = TBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.rvc.rawValue
                let nextNavigationController = UINavigationController(rootViewController: nextViewController)
                self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
                break
            }
            break
        default:
            break
        }
    }
}
