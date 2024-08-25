//
//  NSMutableAttributedString+Extensions.swift
//  digio
//
//  Created by Ian Fagundes on 25/08/24.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func applyBoldFont(to text: String, withFont font: UIFont) {
        let range = (self.string as NSString).range(of: text)
        self.addAttribute(.font, value: font, range: range)
    }
    
    func applyColor(to text: String, withColor color: UIColor) {
        let range = (self.string as NSString).range(of: text)
        self.addAttribute(.foregroundColor, value: color, range: range)
    }
}
