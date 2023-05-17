//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 12.05.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let userResult = try decoder.decode(T.self, from: data)
                completion(.success(userResult))
                
            } catch {
                completion(.failure(error))
            }
        })
        return task
    }
} 
