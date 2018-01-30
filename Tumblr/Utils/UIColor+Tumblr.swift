//
//  UIColor+Tumblr.swift
//  Tumblr
//
//  Created by Alex Demchenko on 28/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red:   CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue:  CGFloat((hex >> 0) & 0xff) / 255,
            alpha: 1
        )
    }

    static var background: UIColor {
        return UIColor(hex: 0xf5f7fa)
    }
}
