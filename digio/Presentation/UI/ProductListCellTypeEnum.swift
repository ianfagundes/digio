//
//  ProductListCellTypeEnum.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation

enum ProductListCellType: Int, CaseIterable {
    case spotlight = 0
    case cashTitle = 1
    case cash = 2
    case productsTitle = 3
    case productsCarousel = 4

    var identifier: String {
        switch self {
        case .spotlight:
            return "SpotlightCell"
        case .cashTitle:
            return "CashTitleCell"
        case .cash:
            return "CashCell"
        case .productsTitle:
            return "ProductsTitleCell"
        case .productsCarousel:
            return "ProductsCarouselCell"
        }
    }
}
