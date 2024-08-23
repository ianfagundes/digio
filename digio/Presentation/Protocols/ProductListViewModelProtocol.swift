//
//  ProductListViewModelProtocol.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation

protocol ProductListViewModelProtocol {
    var products: [Product] { get }
    var spotlightItems: [SpotlightItem] { get }
    var cashInfo: CashInfo? { get }
    
    var delegate: ProductListViewModelDelegate? { get set }
    
    func fetchProducts()
}
