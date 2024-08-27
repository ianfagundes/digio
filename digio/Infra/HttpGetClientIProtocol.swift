//
//  HttpGetClient.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation

protocol HttpGetClientProtocol {
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
