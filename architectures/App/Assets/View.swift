//
//  View.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class View: UIView {
    var toView: BalanceView!
    var fromView: BalanceView!
    var transferButton: UIButton!
    var resetButton: UIButton!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)

        configureView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        layoutView()

        self.layoutIfNeeded()
    }
}

extension View {
    private func configureView() {
        view: do {
            self.backgroundColor = .white
        }

        toView: do {
            self.toView = BalanceView()
            self.addSubview(self.toView)
        }

        fromView: do {
            self.fromView = BalanceView()
            self.addSubview(self.fromView)
        }

        transferButton: do {
            self.transferButton = { () -> UIButton in
                let button = UIButton()
                button.setTitle("TRANSFER", for: .normal)
                button.setTitleColor(.blue, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                return button
            }()
            self.addSubview(self.transferButton)
        }

        resetButton: do {
            self.resetButton = { () -> UIButton in
                let button = UIButton()
                button.setTitle("RESET", for: .normal)
                button.setTitleColor(.red, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                return button
            }()
            self.addSubview(self.resetButton)
        }
    }
}

extension View {
    public func layoutView() {
        toView: do {
            let height: CGFloat = 80
            self.toView.center = CGPoint(x: self.center.x, y: 0)
            self.toView.frame = CGRect(x: 0, y: self.bounds.height/10*2 - 15, width: self.bounds.width, height: height)
        }

        fromView: do {
            let height: CGFloat = 80
            self.fromView.center = CGPoint(x: self.center.x, y: 0)
            self.fromView.frame = CGRect(x: 0, y: self.bounds.height/10*2 + self.toView.bounds.height, width: self.bounds.width, height: height)
        }

        transferButton: do {
            self.transferButton.center = CGPoint(x: self.center.x, y: 0)
            self.transferButton.frame = CGRect(x: 0, y: self.bounds.height/10*7 - 15, width: self.bounds.width, height: self.bounds.height/10)
        }

        resetButton: do {
            self.resetButton.center = CGPoint(x: self.center.x, y: 0)
            self.resetButton.frame = CGRect(x: 0, y: self.bounds.height/10*8, width: self.bounds.width, height: self.bounds.height/10)
        }
    }
}
