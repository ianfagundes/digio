//
//  ProductCarrouselCollectionViewCell.swift
//  digio
//
//  Created by Ian Fagundes on 24/08/24.
//

import Foundation
import TinyConstraints
import UIKit

class ProductCarrouselCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ProductCarrouselCollectionViewCell"

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    // MARK: - Inicializador

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        setupCardView()
        setupImageView()
        setupBottomLine()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCardView() {
        contentView.addSubview(cardView)
        cardView.edgesToSuperview(insets: TinyEdgeInsets(top: 8, left: 16, bottom: 16, right: 16))
    }

    private func setupImageView() {
        cardView.addSubview(imageView)

        imageView.centerInSuperview()
        imageView.width(to: cardView, multiplier: 0.6)
        imageView.height(to: cardView, multiplier: 0.6)
    }

    private func setupBottomLine() {
        contentView.addSubview(bottomLine)

        bottomLine.height(1)
        bottomLine.topToBottom(of: cardView, offset: 16)
        bottomLine.leadingToSuperview(offset: 8)
        bottomLine.trailingToSuperview(offset: 8)
    }

    private func setupShadow() {
        contentView.applyShadow()
    }

    func configure(with item: ProductItem) {
        if let url = URL(string: item.imageURL) {
            imageView.load(url: url, withCornerRadius: 10, contentMode: .scaleAspectFit)
        }
    }
}
