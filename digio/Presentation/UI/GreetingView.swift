//
//  GreetingView.swift
//  digio
//
//  Created by Ian Fagundes on 25/08/24.
//

import Foundation
import UIKit

class GreetingView: UIView {

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let greetingLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Olá, Maria"
        lb.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lb.textColor = .black
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    init(icon: UIImage?) {
        super.init(frame: .zero)
        iconImageView.image = icon
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(iconImageView)
        addSubview(greetingLabel)
        
        iconImageView.leadingToSuperview()
        iconImageView.centerYToSuperview()
        iconImageView.width(32)
        iconImageView.height(32)
        iconImageView.layoutIfNeeded()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.layer.masksToBounds = true
        
        greetingLabel.leadingToTrailing(of: iconImageView, offset: 8)
        greetingLabel.trailingToSuperview()
        greetingLabel.centerYToSuperview()
    }
}
