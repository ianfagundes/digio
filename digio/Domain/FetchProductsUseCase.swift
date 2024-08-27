//
//  FetchProductsUseCase.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation

class DefaultFetchProductsUseCase: FetchProductsUseCaseProtocol {
    private let productRepository: ProductRepositoryProtocol

    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }

    func execute(completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        productRepository.fetchProducts(completion: completion)
    }
}
