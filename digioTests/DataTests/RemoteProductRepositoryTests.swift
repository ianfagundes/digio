//
//  digioTests.swift
//  digioTests
//
//  Created by Ian Fagundes on 22/08/24.
//

@testable import digio
import XCTest

class RemoteProductRepositoryTests: XCTestCase {
    private func makeSUT(url: URL = makeUrl()) -> (sut: RemoteProductRepository, client: HttpClientSpy) {
        let clientSpy = HttpClientSpy()
        let sut = RemoteProductRepository(client: clientSpy, url: url)
        return (sut, clientSpy)
    }

    func test_fetchProducts_callsHttpClientWithCorrectURL() {
        let url = makeUrl()
        let (sut, clientSpy) = makeSUT(url: url)

        sut.fetchProducts { _ in }
        XCTAssertEqual(clientSpy.url, url)
    }

    func test_fetchProducts_deliversProductResponseOnSuccess() {
        let (sut, clientSpy) = makeSUT(url: makeUrl())

        let productResponse = ProductResponse(
            spotlight: [SpotlightItem(name: "Test", bannerURL: "https://example.com/banner", description: "Test Description")],
            products: [ProductItem(name: "Product", imageURL: "https://example.com/image", description: "Product Description")],
            cash: CashInfoItem(title: "Cash", bannerURL: "https://example.com/cash", description: "Cash Description")
        )
        
        let data = try! JSONEncoder().encode(productResponse)

        var receivedResult: Result<ProductResponse, Error>?

        sut.fetchProducts { result in
            receivedResult = result
        }
        clientSpy.complete(with: .success(data))

        switch receivedResult {
        case let .success(receivedProducts):
            XCTAssertEqual(receivedProducts, productResponse)
        default:
            XCTFail("Expected success with \(productResponse), got \(String(describing: receivedResult)) instead")
        }
    }

    func test_fetchProducts_deliversErrorOnClientFailure() {
        let (sut, clientSpy) = makeSUT(url: makeUrl())
        let expectedError = NSError(domain: "test", code: 0)

        var receivedResult: Result<ProductResponse, Error>?

        sut.fetchProducts { result in
            receivedResult = result
        }
        clientSpy.complete(with: .failure(expectedError))

        switch receivedResult {
        case let .failure(receivedError as NSError):
            XCTAssertEqual(receivedError, expectedError)
        default:
            XCTFail("Expected failure with \(expectedError), got \(String(describing: receivedResult)) instead")
        }
    }

    class HttpClientSpy: HttpGetClientProtocol {
        var url: URL?
        var completion: ((Result<Data, Error>) -> Void)?

        func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            self.url = url
            self.completion = completion
        }

        func complete(with result: Result<Data, Error>) {
            completion?(result)
        }
    }
}
