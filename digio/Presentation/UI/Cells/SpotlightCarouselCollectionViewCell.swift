//
//  SpotlightCarouselCollectionViewCell.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import TinyConstraints
import UIKit

class SpotlightCarouselCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "SpotlightCarouselCollectionViewCell"

    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContainerView() {
        contentView.addSubview(shadowView)
        shadowView.edgesToSuperview(insets: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    private func setupImageView() {
        shadowView.addSubview(imageView)
        imageView.edgesToSuperview()
    }

    func configure(with item: SpotlightItem) {
        if let url = URL(string: item.bannerURL) {
            imageView.load(url: url, withCornerRadius: 10, contentMode: .scaleAspectFill)
        }
    }
}
