//
//  URLSessionAdapterTests.swift
//  digioTests
//
//  Created by Ian Fagundes on 26/08/24.
//

@testable import digio
import XCTest

class URLSessionAdapterTests: XCTestCase {
    func test_getFromURL_performsRequestWithCorrectURL() {
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)

        let sut = URLSessionAdapter(session: session)

        let exp = expectation(description: "waiting")

        URLProtocolStub.observerRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
            exp.fulfill()
        }

        sut.get(from: url) { _ in }

        wait(for: [exp], timeout: 1)
    }

    func test_getFromURL_deliversDataOnWithCode200() {
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)

        let sut = URLSessionAdapter(session: session)

        let expectedData = Data("{\"status\":\"valid data\"}".utf8)
        URLProtocolStub.stub(data: expectedData, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), error: nil)

        let exp = expectation(description: "waiting")

        sut.get(from: url) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedData)
            case .failure:
                XCTFail("Expected success, got \(result) instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionAdapter(session: session)
        
        let expectedError = NetworkError.unknown
        URLProtocolStub.stub(data: nil, response: nil, error: expectedError)
        
        let exp = expectation(description: "waiting")
        
        sut.get(from: url) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success instead")
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as? NetworkError, expectedError)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getFromURL_failsOnNilData() {
        let url = URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)

        let sut = URLSessionAdapter(session: session)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            
        URLProtocolStub.stub(data: nil, response: response, error: nil)

        let exp = expectation(description: "waiting")

        sut.get(from: url) { result in
            switch result {
            case .failure(let error):
                if case NetworkError.noData = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Expected noData error, but received a different error: \(error)")
                }
            default:
                XCTFail("Expected fail, but received success instead. \(result)")
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

    static func stub(data: Data?, response: URLResponse?, error: Error?) {
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
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }
        }
    }
    
    override open func stopLoading() {}
}

