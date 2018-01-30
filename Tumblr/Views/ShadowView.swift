//
//  ShadowView.swift
//  Tumblr
//
//  Created by Alex Demchenko on 28/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override var bounds: CGRect {
        didSet {
            configureShadow()
        }
    }

    private func configureShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.1
        layer.shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 6, height: 6)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
