//
//  ProductListViewModel.swift
//  digio
//
//  Created by Ian Fagundes on 23/08/24.
//

import Foundation

protocol ProductListViewModelDelegate: AnyObject {
    func didFetchProductsSuccessfully()
    func didFailToFetchProducts(with error: Error)
}

class ProductListViewModel: ProductListViewModelProtocol {
    weak var delegate: ProductListViewModelDelegate?
    
    private let fetchProductsUseCase: FetchProductsUseCaseProtocol
    
    private(set) var products: [ProductItem] = []
    private(set) var spotlightItems: [SpotlightItem] = []
    private(set) var cashInfo: CashInfo?
    private(set) var cashTitle: String?
    
    init(fetchProductsUseCase: FetchProductsUseCaseProtocol) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }
    
    func fetchProducts() {
        fetchProductsUseCase.execute { [weak self] result in
            switch result {
            case .success(let productResponse):
                self?.products = productResponse.products
                self?.spotlightItems = productResponse.spotlight
                self?.cashInfo = productResponse.cash
                self?.cashTitle = productResponse.cash.title
                self?.delegate?.didFetchProductsSuccessfully()
            case .failure(let error):
                self?.delegate?.didFailToFetchProducts(with: error)
            }
        }
    }
}
