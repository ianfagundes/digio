//
//  ProductListViewModelTest.swift
//  digioTests
//
//  Created by Ian Fagundes on 26/08/24.
//

import Foundation
import XCTest

@testable import digio

class ProductListViewModelTests: XCTestCase {
    
    private var sut: ProductListViewModel!
    private var useCaseSpy: FetchProductsUseCaseSpy!
    private var delegateSpy: ProductListViewModelDelegateSpy!

    override func setUp() {
        super.setUp()
        (sut, useCaseSpy, delegateSpy) = makeSUT()
    }

    override func tearDown() {
        sut = nil
        useCaseSpy = nil
        delegateSpy = nil
        super.tearDown()
    }

    func test_fetchProducts_shouldCallFetchProductsUseCase() {
        sut.fetchProducts()
        XCTAssertNotNil(useCaseSpy.completion)
    }

    func test_fetchProducts_shouldNotifyDelegateOnSuccess() {
        let productResponse = makeProductResponse()

        sut.fetchProducts()
        useCaseSpy.completeWithSuccess(productResponse)

        XCTAssertEqual(sut.products, productResponse.products)
        XCTAssertEqual(sut.spotlightItems, productResponse.spotlight)
        XCTAssertEqual(sut.cashInfo, productResponse.cash)
        XCTAssertEqual(sut.cashTitle, productResponse.cash.title)
        XCTAssertEqual(delegateSpy.messages, [.didFetchProductsSuccessfully])
    }

    func test_fetchProducts_shouldNotifyDelegateOnFailure() {
        let expectedError = NSError(domain: "test", code: 0, userInfo: nil)

        sut.fetchProducts()
        useCaseSpy.completeWithError(expectedError)

        XCTAssertEqual(delegateSpy.messages, [.didFailToFetchProducts])
    }

    // MARK: - Helpers

    private func makeSUT() -> (ProductListViewModel, FetchProductsUseCaseSpy, ProductListViewModelDelegateSpy) {
        let useCaseSpy = FetchProductsUseCaseSpy()
        let delegateSpy = ProductListViewModelDelegateSpy()
        let sut = ProductListViewModel(fetchProductsUseCase: useCaseSpy)
        sut.delegate = delegateSpy
        return (sut, useCaseSpy, delegateSpy)
    }
    
    private func makeProductResponse(
        spotlight: [SpotlightItem] = [SpotlightItem(name: "Test", bannerURL: "https://example.com/banner", description: "Test Description")],
        products: [ProductItem] = [ProductItem(name: "Product", imageURL: "https://example.com/image", description: "Product Description")],
        cash: CashInfoItem = CashInfoItem(title: "Cash", bannerURL: "https://example.com/cash", description: "Cash Description")
    ) -> ProductResponse {
        return ProductResponse(spotlight: spotlight, products: products, cash: cash)
    }
}

// MARK: - ProductListViewModelDelegateSpy e FetchProductsUseCaseSpy

class ProductListViewModelDelegateSpy: ProductListViewModelDelegate {
    enum Message: Equatable {
        case didFetchProductsSuccessfully
        case didFailToFetchProducts
    }

    private(set) var messages = [Message]()

    func didFetchProductsSuccessfully() {
        messages.append(.didFetchProductsSuccessfully)
    }

    func didFailToFetchProducts(with error: Error) {
        messages.append(.didFailToFetchProducts)
    }
}

class FetchProductsUseCaseSpy: FetchProductsUseCaseProtocol {
    var completion: ((Result<ProductResponse, Error>) -> Void)?

    func execute(completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        self.completion = completion
    }

    func completeWithSuccess(_ productResponse: ProductResponse) {
        completion?(.success(productResponse))
    }

    func completeWithError(_ error: Error) {
        completion?(.failure(error))
    }
}
