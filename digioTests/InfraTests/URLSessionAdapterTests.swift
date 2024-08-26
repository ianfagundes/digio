//
//  URLSessionAdapterTests.swift
//  digioTests
//
//  Created by Ian Fagundes on 26/08/24.
//

@testable import digio
import XCTest

class URLSessionAdapterTests: XCTestCase {
    // MARK: - Resposta Bem-Sucedida com Dados Válidos

    func test__deliversDataOnWithCode200() {
        let expectedData = makeValidData()
        let response = HTTPURLResponse(url: makeUrl(), statusCode: 200, httpVersion: nil, headerFields: nil)!

        expectResult(.success(expectedData), when: (data: expectedData, response: response, error: nil))
    }

    // MARK: - Erro na Requisição (Erro no Cliente)

    func test_failsOnRequestError() {
        let expectedError = NetworkError.invalidResponse

        expectResult(.failure(expectedError), when: (data: nil, response: HTTPURLResponse(url: makeUrl(), statusCode: 500, httpVersion: nil, headerFields: nil)!, error: nil))
    }

    // MARK: - Resposta Bem-Sucedida sem Dados ou com Dados Vazios

    func test_failsOnNilData_EmptyData() {
        let response = HTTPURLResponse(url: makeUrl(), statusCode: 200, httpVersion: nil, headerFields: nil)!
        expectResult(.failure(NetworkError.noData), when: (data: nil, response: response, error: nil))
    }

    // MARK: - Resposta com Código HTTP de Erro (4xx ou 5xx)

    func test_failsOnNon200HTTPResponse() {
        let response = HTTPURLResponse(url: makeUrl(), statusCode: 404, httpVersion: nil, headerFields: nil)!
        expectResult(.failure(NetworkError.invalidResponse), when: (data: nil, response: response, error: nil))
    }

    // MARK: - Requisição com a URL Incorreta

    func test_failsOnInvalidURL() {
        let invalidURL = URL(string: "invalid-url")!
        let sut = makeSUT()

        let exp = expectation(description: "waiting")

        sut.get(from: invalidURL) { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
            default:
                XCTFail("Expected failure, got success instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    // MARK: - Requisição com a URL Correta

    func test_performsRequestWithCorrectURL() {
        let url = makeUrl()
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
    
    // MARK: - Requisição sem Conexão
    func test_failsOnNoConnectivity() {
        let expectedError = NetworkError.noConnectivity

        expectResult(.failure(expectedError), when: (data: nil, response: nil, error: NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)))
    }
    
    // MARK: - Teste HttpError
    func test_failsOnHTTPError() {
        let expectedError = NetworkError.httpError(500)

        expectResult(.failure(expectedError), when: (data: nil, response: HTTPURLResponse(url: makeUrl(), statusCode: 500, httpVersion: nil, headerFields: nil)!, error: nil))
    }
    
    // MARK: - Teste Não Autorizado
    func test_failsOnUnauthorized() {
        let expectedError = NetworkError.unauthorized

        expectResult(.failure(expectedError), when: (data: nil, response: HTTPURLResponse(url: makeUrl(), statusCode: 401, httpVersion: nil, headerFields: nil)!, error: nil))
    }
}

// MARK: - Funcões de Helper

extension URLSessionAdapterTests {
    private func makeSUT() -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionAdapter(session: session)
    }

    private func expectResult(_ expectedResult: Result<Data, NetworkError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) {
        let sut = makeSUT()

        URLProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")

        sut.get(from: makeUrl()) { receivedResult in
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

// MARK: - URLProtocolStub

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
