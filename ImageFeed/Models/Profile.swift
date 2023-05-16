//
//  Profile.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 07.05.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(model: ProfileResult) {
        self.username = model.username
        self.name = "\(model.firstName) \(model.lastName)"
        self.loginName = "@\(model.username)"
        self.bio = model.bio ?? ""
    }
    
}
