//
//  View.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class View: UIView {
    var balanceToLabel: UILabel!
    var balanceFromLabel: UILabel!
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
            self.translatesAutoresizingMaskIntoConstraints = false
        }

        balanceToLabel: do {
            self.balanceToLabel = { () -> UILabel in
                let label = UILabel()
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont(name: "Times New Roman", size: 50)
                return label
            }()
            self.addSubview(self.balanceToLabel)
        }

        balanceFromLabel: do {
            self.balanceFromLabel = { () -> UILabel in
                let label = UILabel()
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont(name: "Times New Roman", size: 50)
                return label
            }()
            self.addSubview(self.balanceFromLabel)
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
        balanceToLabel: do {
            self.balanceToLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            self.balanceToLabel.center = CGPoint(x: self.center.x, y: self.center.y - 200)
        }

        balanceFromLabel: do {
            self.balanceFromLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            self.balanceFromLabel.center = CGPoint(x: self.center.x, y: self.center.y - 100)
        }

        transferButton: do {
            self.transferButton.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
            self.transferButton.center = CGPoint(x: self.center.x, y: self.center.y + 200)
        }

        resetButton: do {
            self.resetButton.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
            self.resetButton.center = CGPoint(x: self.center.x, y: self.center.y + 300)
        }
    }
}
