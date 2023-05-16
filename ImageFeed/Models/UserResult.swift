//
//  UserResult.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 08.05.2023.
//

import Foundation

struct UserResult: Codable {
    var profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        var small: String
    }
}
