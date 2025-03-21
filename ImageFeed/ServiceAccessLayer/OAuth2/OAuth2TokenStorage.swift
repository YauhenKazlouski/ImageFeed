//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by PandaPo on 02.03.25.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    //MARK: -Singleton
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let keychainWrapper = KeychainWrapper.standard
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenKey)
        }
        
        set {
            if let newValue {
                keychainWrapper.set(newValue, forKey: tokenKey)
            } else {
                keychainWrapper.removeObject(forKey: tokenKey)
            }
        }
    }
}
