//
//  digioTests.swift
//  digioTests
//
//  Created by Ian Fagundes on 22/08/24.
//

@testable import digio
import XCTest

class RemoteProductRepositoryTests: XCTestCase {

    func test_fetchProducts_callsHttpClientWithCorrectURL() {
        
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let clientSpy = HttpClientSpy()
        let sut = RemoteProductRepository(client: clientSpy, url: url)
        
        sut.fetchProducts { _ in }
        XCTAssertEqual(clientSpy.url, url)
    }
    
    func test_fetchProducts_deliversProductResponseOnSuccess() {
        
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let clientSpy = HttpClientSpy()
        let sut = RemoteProductRepository(client: clientSpy, url: url)
        
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
        case .success(let receivedProducts):
            XCTAssertEqual(receivedProducts, productResponse)
        default:
            XCTFail("Expected success with \(productResponse), got \(String(describing: receivedResult)) instead")
        }
    }
    
    func test_fetchProducts_deliversErrorOnClientFailure() {
        
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let clientSpy = HttpClientSpy()
        let sut = RemoteProductRepository(client: clientSpy, url: url)
        let expectedError = NSError(domain: "test", code: 0)
        
        var receivedResult: Result<ProductResponse, Error>?
        
        sut.fetchProducts { result in
            receivedResult = result
        }
        clientSpy.complete(with: .failure(expectedError))

        switch receivedResult {
        case .failure(let receivedError as NSError):
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
