//
//  ProductRepositoryProtocol.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation
protocol ProductRepositoryProtocol {
    func fetchProducts(completion: @escaping (Result<ProductResponse, Error>) -> Void)
}
