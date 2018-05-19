//
//  DetailsViewController.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

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

extension DetailViewController {
    private func configureView() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
    }
    private func layoutView() {
    }
}

extension DetailViewController {
    // hide master and detail fullscreen in leftBarButtonItem settings.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        let horizontal = self.traitCollection.horizontalSizeClass
        if horizontal == UIUserInterfaceSizeClass.regular {
            self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
    @objc func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            let horizontal = self.traitCollection.horizontalSizeClass
            if horizontal == UIUserInterfaceSizeClass.regular {
                self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            }
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            //
        }
    }
}
