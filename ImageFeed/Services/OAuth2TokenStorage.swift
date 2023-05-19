//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 21.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "bearerToken")
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: "bearerToken")
        }
    }
    
}
