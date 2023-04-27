//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 21.04.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
    
    var selfProfileRequest: URLRequest {
        URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
    }
    func profileImageURLRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
    }
    func photosRequest(page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos?"
          + "page=\(page)"
          + "&&per_page=\(perPage)", httpMethod: "GET"
        )
    }
    func likeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
          path: "/photos/\(photoId)/like",
          httpMethod: "POST"
        )
    }
    func unlikeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
          path: "/photos/\(photoId)/like",
          httpMethod: "DELETE"
        )
    }
    func authTokenRequest(code: String) -> URLRequest {
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
