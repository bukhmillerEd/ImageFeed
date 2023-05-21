//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 20.05.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let description: String
    let likedByUser: Bool
    let width: Int
    let height: Int
    let urls: UrlsResult
    
    struct UrlsResult: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}
