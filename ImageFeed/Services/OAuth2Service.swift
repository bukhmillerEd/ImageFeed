//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 20.04.2023.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private var tokenStorage = OAuth2TokenStorage.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private (set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    private init() {}
    
    func fetchAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        
        task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .failure(let error):
                self?.lastCode = nil
                completion(.failure(error))
            case .success(let body):
                completion(.success(body.accessToken))
                self?.task = nil
            }
        })
        task?.resume()
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
        )
    }
    
    
}
