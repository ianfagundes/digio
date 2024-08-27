//
//  SpotlightTableViewCell.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation
import TinyConstraints
import UIKit

protocol SpotlightCarouselTableViewCellDelegate: AnyObject {
    func spotlightCarouselTableViewCell(_ cell: SpotlightCarouselTableViewCell, didSelectItem item: SpotlightItem)
}

class SpotlightCarouselTableViewCell: UITableViewCell {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 288, height: 128)
        layout.sectionInset = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()

    weak var delegate: SpotlightCarouselTableViewCellDelegate?
    private var spotlightItems: [SpotlightItem] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none 
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SpotlightCarouselCollectionViewCell.self, forCellWithReuseIdentifier: SpotlightCarouselCollectionViewCell.identifier)

        // Constraints
        collectionView.leadingToSuperview(offset: 16)
        collectionView.trailingToSuperview(offset: 16)
        collectionView.topToSuperview()
        collectionView.bottomToSuperview()
        collectionView.height(128)
    }

    func configure(with spotlightItems: [SpotlightItem]) {
        self.spotlightItems = spotlightItems
        collectionView.reloadData()
    }
}

extension SpotlightCarouselTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotlightItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotlightCarouselCollectionViewCell.identifier, for: indexPath) as? SpotlightCarouselCollectionViewCell else { return UICollectionViewCell() }
        let item = spotlightItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = spotlightItems[indexPath.item]
        delegate?.spotlightCarouselTableViewCell(self, didSelectItem: selectedItem)
    }
}
