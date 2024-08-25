//
//  ProductListViewModelProtocol.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation

protocol ProductListViewModelProtocol {
    var products: [ProductItem] { get }
    var spotlightItems: [SpotlightItem] { get }
    var cashInfo: CashInfoItem? { get }
    var cashTitle: String? { get }
    
    var delegate: ProductListViewModelDelegate? { get set }
    
    func fetchProducts()
}
