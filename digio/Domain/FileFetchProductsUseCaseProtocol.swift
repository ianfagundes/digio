//
//  FileFetchProductsUseCaseProtocol.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation
protocol FetchProductsUseCaseProtocol {
    func execute(completion: @escaping (Result<ProductResponse, Error>) -> Void)
}
