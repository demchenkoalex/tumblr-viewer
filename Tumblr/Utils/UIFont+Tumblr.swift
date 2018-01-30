//
//  UIFont+Tumblr.swift
//  Tumblr
//
//  Created by Alex Demchenko on 30/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import UIKit

extension UIFont {
    static func avenirRegular(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Book", size: size)
    }

    static func avenirBold(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Heavy", size: size)
    }
}
