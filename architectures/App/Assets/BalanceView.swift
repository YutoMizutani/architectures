//
//  BalanceView.swift
//  architectures
//
//  Created by YutoMizutani on 2018/05/24.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class BalanceView: UIView {
    var nameLabel: UILabel!
    var valueLabel: UILabel!

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

extension BalanceView {
    private func configureView() {
        nameLabel: do {
            self.nameLabel = { () -> UILabel in
                let label = UILabel()
                label.textAlignment = .left
                label.textColor = .black
                label.font = UIFont(name: "Times New Roman", size: 20)
                return label
            }()
            self.addSubview(self.nameLabel)
        }

        valueLabel: do {
            self.valueLabel = { () -> UILabel in
                let label = UILabel()
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont(name: "Times New Roman", size: 50)
                return label
            }()
            self.addSubview(self.valueLabel)
        }
    }
}

extension BalanceView {
    public func layoutView() {
        nameLabel: do {
            self.nameLabel.center = CGPoint(x: self.center.x - 150, y: 0)
            self.nameLabel.frame = CGRect(x: self.nameLabel.center.x, y: 0, width: self.bounds.width, height: self.bounds.height/2)
        }

        valueLabel: do {
            self.valueLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.valueLabel.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }
    }
}
