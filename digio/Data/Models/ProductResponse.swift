//
//  ProductResponse.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation

struct ProductResponse: Codable, Equatable {
    let spotlight: [SpotlightItem]
    let products: [ProductItem]
    let cash: CashInfoItem
}
