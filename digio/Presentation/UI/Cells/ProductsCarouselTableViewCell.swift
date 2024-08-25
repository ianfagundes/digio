//
//  CarouselTableViewCell.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import UIKit

protocol ProductsCarouselTableViewCellDelegate: AnyObject {
    func productsCarouselTableViewCell(_ cell: ProductsCarouselTableViewCell, didSelectItem item: ProductItem)
}

class ProductsCarouselTableViewCell: UITableViewCell {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSize(width: 124, height: 124)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    weak var delegate: ProductsCarouselTableViewCellDelegate?
    private var productCarouselItems: [ProductItem] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCarrouselCollectionViewCell.self, forCellWithReuseIdentifier: ProductCarrouselCollectionViewCell.identifier)

        // Constraints
        collectionView.edgesToSuperview()
        collectionView.height(124)
    }

    func configure(with products: [ProductItem]) {
        productCarouselItems = products
        collectionView.reloadData()
    }
}

extension ProductsCarouselTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCarouselItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCarrouselCollectionViewCell.identifier, for: indexPath) as? ProductCarrouselCollectionViewCell else { return UICollectionViewCell() }
        let item = productCarouselItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = productCarouselItems[indexPath.item]
        delegate?.productsCarouselTableViewCell(self, didSelectItem: selectedItem)
    }
}
