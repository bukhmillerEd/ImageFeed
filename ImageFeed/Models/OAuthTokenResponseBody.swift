//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 20.04.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
