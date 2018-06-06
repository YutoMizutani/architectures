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
            var nextViewController: UIViewController!

            switch indexPath.row {
            // PDS
            case 0:
                nextViewController = PDSBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.pds.short
                break
            // MVC
            case 1:
                nextViewController = MVCBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvc.short
                break
            // MVP
            case 2:
                nextViewController = MVPBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvp.short
                break
            // MVVM
            case 3:
                nextViewController = MVVMBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.mvvm.short
                break
            // DDD
            case 4:
                nextViewController = DDDBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.ddd.short
                break
            // VIPER
            case 5:
                nextViewController = VIPERBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.viper.short
                break
            // Clean Architecture
            case 6:
                nextViewController = CABuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.ca.short
                break
            // RxFeedback
            case 7:
                nextViewController = RFBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.rf.short
                break
            // RVC
            case 8:
                nextViewController = RVCBuilder().build()
                nextViewController.navigationItem.title = MasterViewControllerEurekaTags.rvc.short
                break
            default:
                return
            }

            let nextNavigationController = UINavigationController(rootViewController: nextViewController)
            self.splitViewController?.showDetailViewController(nextNavigationController, sender: self)
            return
        default:
            break
        }
    }
}
