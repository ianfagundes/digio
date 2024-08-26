//
//  DataFactory.swift
//  digioTests
//
//  Created by Ian Fagundes on 26/08/24.
//

import Foundation

struct DataFactory {
    static func makeValidData() -> Data {
        return Data("{\"status\":\"valid data\"}".utf8)
    }
}
