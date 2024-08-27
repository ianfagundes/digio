//
//  DetailsViewController.swift
//  digio
//
//  Created by Ian Fagundes on 25/08/24.
//

import UIKit
import TinyConstraints

class DetailsViewController: UIViewController {

    private var itemImageViewHeightConstraint: NSLayoutConstraint?
    private var itemImageViewAspectRatioConstraint: NSLayoutConstraint?

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
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

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Adicionar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(itemImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(addButton)

        titleLabel.topToSuperview(offset: 16, usingSafeArea: true)
        titleLabel.leadingToSuperview(offset: 32)
        titleLabel.trailingToSuperview(offset: 32)
        titleLabel.centerXToSuperview()

        itemImageView.leadingToSuperview(offset: 64)
        itemImageView.trailingToSuperview(offset: 64)
        itemImageView.topToBottom(of: titleLabel, offset: 16)
        itemImageViewHeightConstraint = itemImageView.height(120)

        descriptionLabel.topToBottom(of: itemImageView, offset: 16)
        descriptionLabel.leadingToSuperview(offset: 32)
        descriptionLabel.trailingToSuperview(offset: 32)

        addButton.bottomToSuperview(offset: -24, usingSafeArea: true)
        addButton.leadingToSuperview(offset: 32)
        addButton.trailingToSuperview(offset: 32)
        addButton.height(50)
        addButton.centerXToSuperview()
    }

    func configure(with item: DetailItemType) {
        let imageURL: URL?
        let title: String?
        let description: String?

        switch item {
        case let .product(product):
            imageURL = URL(string: product.imageURL)
            title = product.name
            description = product.description

        case let .banner(banner):
            imageURL = URL(string: banner.bannerURL)
            title = banner.name
            description = banner.description

        case let .service(service):
            imageURL = URL(string: service.bannerURL)
            title = service.title
            description = service.description
        }

        if let imageURL = imageURL {
            loadAndAdjustImage(from: imageURL)
        } else {
            itemImageView.image = nil
        }

        titleLabel.text = title
        descriptionLabel.text = description
    }

    private func loadAndAdjustImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.adjustImageViewSize(for: image)
                    self.itemImageView.image = image
                }
            }
        }
    }

    private func adjustImageViewSize(for image: UIImage) {
        let imageRatio = image.size.width / image.size.height
        
        if let existingAspectRatioConstraint = itemImageViewAspectRatioConstraint {
            itemImageView.removeConstraint(existingAspectRatioConstraint)
        }
        
        itemImageViewAspectRatioConstraint = itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: imageRatio)
        itemImageViewAspectRatioConstraint?.isActive = true

        // reaplica.
        view.layoutIfNeeded()
        itemImageView.layer.cornerRadius = 16
    }
}
