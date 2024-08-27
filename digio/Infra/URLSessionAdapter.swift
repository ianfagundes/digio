//
//  URLSessionAdapter.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import Foundation

class URLSessionAdapter: HttpGetClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let scheme = url.scheme, scheme == "http" || scheme == "https" else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost {
                    completion(.failure(NetworkError.noConnectivity))
                    return
                }
                completion(.failure(NetworkError.unknown))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            switch httpResponse.statusCode {
            case 200 ... 299:
                break
            case 401:
                completion(.failure(NetworkError.unauthorized))
                return
            default:
                completion(.failure(NetworkError.httpError(httpResponse.statusCode)))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}
