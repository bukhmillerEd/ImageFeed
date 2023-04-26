//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 21.04.2023.
//

import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "bearerToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bearerToken")
        }
    }
    
}
