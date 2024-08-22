//
//  ProductResponse.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation

struct ProductResponse: Codable {
    let spotlight: [SpotlightItem]
    let products: [Product]
    let cash: CashInfo
}
