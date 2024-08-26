//
//  URLFactory.swift
//  digioTests
//
//  Created by Ian Fagundes on 26/08/24.
//

import Foundation
struct URLFactory {
    static func makeProductsURL() -> URL {
        return URL(string: "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products")!
    }
}
