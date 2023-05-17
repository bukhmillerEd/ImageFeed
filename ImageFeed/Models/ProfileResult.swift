//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 07.05.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
