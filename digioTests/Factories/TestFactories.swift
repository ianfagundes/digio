//
//  TestFactories.swift
//  digioTests
//
//  Created by Ian Fagundes on 26/08/24.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeValidData() -> Data {
    return Data("{\"status\":\"valid data\"}".utf8)
}

func makeUrl() -> URL {
    return URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
}

func makeInvalidUrl() -> URL {
    return URL(string: "invalid-url")!
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(url: makeUrl(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
