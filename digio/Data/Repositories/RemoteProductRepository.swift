//
//  RemoteProductRepository.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation
class RemoteProductRepository: ProductRepositoryProtocol {
    private let client: HttpGetClientProtocol
    private let url: URL

    init(client: HttpGetClientProtocol, url: URL) {
        self.client = client
        self.url = url
    }

    func fetchProducts(completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                    completion(.success(productResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
