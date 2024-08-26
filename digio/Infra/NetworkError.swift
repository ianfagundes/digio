//
//  NetworkError.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case httpError(Int)
    case unauthorized
    case unknown
    case invalidResponse
    case noConnectivity
}
