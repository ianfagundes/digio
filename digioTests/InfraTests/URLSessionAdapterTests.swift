//
//  URLSessionAdapterTests.swift
//  digioTests
//
//  Created by Ian Fagundes on 26/08/24.
//

@testable import digio
import XCTest

class URLSessionAdapterTests: XCTestCase {
    // is valid case (Url test)
    func test_getFromURL_performsRequestWithCorrectURL() {
        let url = URLFactory.makeProductsURL()
        let sut = makeSUT()

        let exp = expectation(description: "waiting")

        URLProtocolStub.observerRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
            exp.fulfill()
        }

        sut.get(from: url) { _ in }

        wait(for: [exp], timeout: 1)
    }

    // is valid case ( data = true, response = true, error = nil)
    func test_getFromURL_deliversDataOnWithCode200() {
        let expectedData = DataFactory.makeValidData()
        let response = HTTPURLResponse(url: URLFactory.makeProductsURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!

        expectResult(.success(expectedData), when: (data: expectedData, response: response, error: nil))
    }

    // is valid case ( data = nil, response = nil, error = true)
    func test_getFromURL_failsOnRequestError() {
        let expectedError = NetworkError.unknown

        expectResult(.failure(expectedError), when: (data: nil, response: HTTPURLResponse(url: URLFactory.makeProductsURL(), statusCode: 500, httpVersion: nil, headerFields: nil)!, error: expectedError))
    }
    
    // is valid case ( data = nil, response = true, error = nil)
    func test_getFromURL_failsOnNilData() {
        let response = HTTPURLResponse(url: URLFactory.makeProductsURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
        expectResult(.failure(NetworkError.noData), when: (data: nil, response: response, error: nil))
    }
}

extension URLSessionAdapterTests {
    private func makeSUT() -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionAdapter(session: session)
    }

    private func expectResult(_ expectedResult: Result<Data, NetworkError>, when stub: (data: Data?, response: HTTPURLResponse, error: Error?), file: StaticString = #file, line: UInt = #line) {
        let sut = makeSUT()

        URLProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")

        sut.get(from: URLFactory.makeProductsURL()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.failure(expectedError), .failure(receivedError)):
                XCTAssertEqual(expectedError, receivedError as? NetworkError, file: file, line: line)
            case let (.success(expectedData), .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), but got \(receivedResult) instead.", file: file, line: line)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }
}

class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    static var emit: ((URLRequest) -> Void)?

    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }

    static func simulate(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error)
    }

    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        if let emit = URLProtocolStub.emit {
            emit(request)
        }
        if let stub = URLProtocolStub.stub {
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            } else {
                client?.urlProtocol(self, didLoad: Data())
            }

            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override open func stopLoading() {}
}
