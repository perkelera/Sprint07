//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anton Rachkov on 31.07.2026.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "oauth2_token"
    
    private init() {}
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: tokenKey)
            } else {
                userDefaults.removeObject(forKey: tokenKey)
            }
        }
    }
}
