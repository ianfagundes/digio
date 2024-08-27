//
//  UIImageView+Extensions.swift
//  digio
//
//  Created by Ian Fagundes on 24/08/24.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, withCornerRadius cornerRadius: CGFloat? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, applyShadow: Bool = false) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    self?.contentMode = contentMode
                    self?.clipsToBounds = true
                    
                    if let cornerRadius = cornerRadius {
                        self?.layer.cornerRadius = cornerRadius
                    } else {
                        self?.layer.cornerRadius = (self?.frame.height ?? 0) / 2
                    }
                    
                    self?.layer.masksToBounds = true

                    if applyShadow {
                        self?.applyShadow(cornerRadius: cornerRadius)
                    }
                }
            }
        }
    }

    private func applyShadow(cornerRadius: CGFloat? = nil) {
        guard let superview = superview else { return }

        superview.layer.shadowColor = UIColor.black.cgColor
        superview.layer.shadowOpacity = 0.25
        superview.layer.shadowOffset = CGSize(width: 0, height: 2)
        superview.layer.shadowRadius = 4
        superview.layer.masksToBounds = false

        if let cornerRadius = cornerRadius {
            superview.layer.shadowPath = UIBezierPath(roundedRect: superview.bounds, cornerRadius: cornerRadius).cgPath
        } else {
            superview.layer.shadowPath = UIBezierPath(rect: superview.bounds).cgPath
        }
    }

    func setImage(named imageName: String?, placeholder: UIImage? = nil) {
        if let imageName = imageName, let image = UIImage(named: imageName) {
            self.image = image
        } else {
            image = placeholder
        }
    }
}
