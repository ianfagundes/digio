//
//  NetworkError.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case httpError(Int)
    case unknown
    case invalidResponse
}
