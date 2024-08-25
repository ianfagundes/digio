//
//  UIView+Extensions.swift
//  digio
//
//  Created by Ian Fagundes on 24/08/24.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow(
        color: UIColor = .black,
        opacity: Float = 0.25,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 4,
        cornerRadius: CGFloat = 10
    ) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}
