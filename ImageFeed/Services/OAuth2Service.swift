//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 20.04.2023.
//

import Foundation

final class OAuth2Service {
    
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    private var tokenStorage = OAuth2TokenStorage()
    
    private (set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    func fetchAuthToken(
        code: String,
        complition: @escaping (Result<String, Error>) -> Void
    ) {
        let request = authTokenRequest(code: code)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                complition(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            guard let data = data else { return }
            do {
                let body = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                complition(.success(body.accessToken))
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        ) }
    
    
}
