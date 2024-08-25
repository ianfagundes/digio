//
//  DetailsViewController.swift
//  digio
//
//  Created by Ian Fagundes on 25/08/24.
//

import Foundation
import UIKit
import TinyConstraints

class DetailsViewController: UIViewController {
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(itemImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)

        itemImageView.topToSuperview(usingSafeArea: true)
        itemImageView.leadingToSuperview()
        itemImageView.trailingToSuperview()
        itemImageView.height(200)

        titleLabel.topToBottom(of: itemImageView, offset: 16)
        titleLabel.leadingToSuperview(offset: 16)
        titleLabel.trailingToSuperview(offset: 16)

        descriptionLabel.topToBottom(of: titleLabel, offset: 8)
        descriptionLabel.leadingToSuperview(offset: 16)
        descriptionLabel.trailingToSuperview(offset: 16)
    }

    func configure(with item: DetailItemType) {
        let imageURL: String?
        let title: String?
        let description: String?
        
        switch item {
        case let .product(product):
            imageURL = product.imageURL
            title = product.name
            description = product.description

        case let .banner(banner):
            imageURL = banner.bannerURL
            title = banner.name
            description = banner.description

        case let .service(service):
            imageURL = service.bannerURL
            title = service.title
            description = service.description
        }

        itemImageView.setImage(named: imageURL)
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
