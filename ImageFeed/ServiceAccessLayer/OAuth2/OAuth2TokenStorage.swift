//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by PandaPo on 02.03.25.
//

import Foundation

final class OAuth2TokenStorage {
    //MARK: -Singleton
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
