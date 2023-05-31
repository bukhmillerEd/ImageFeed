//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 21.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "bearerToken")
        }
        set {
            guard let newValue else {
                KeychainWrapper.standard.removeObject(forKey: "bearerToken")
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: "bearerToken")
        }
    }
    
}
