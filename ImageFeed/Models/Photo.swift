//
//  Photo.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 20.05.2023.
//

import Foundation

struct Photo {
    var id: String
    var size: CGSize
    var createdAt: Date?
    var welcomeDescription: String
    var thumbImageURL: String
    var largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        id = photoResult.id
        size = CGSize(width: photoResult.width, height: photoResult.height)
        let date = photoResult.createdAt // "2016-05-03T11:00:28-04:00"
        let dateFormatter = ISO8601DateFormatter()
        createdAt = dateFormatter.date(from: date)
        isLiked = photoResult.likedByUser
        largeImageURL = photoResult.urls.full
        thumbImageURL = photoResult.urls.thumb
        welcomeDescription = photoResult.description ?? ""
    }
}
