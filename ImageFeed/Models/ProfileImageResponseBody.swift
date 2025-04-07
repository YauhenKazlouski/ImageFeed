//
//  ProfileImageResponseBody.swift
//  ImageFeed
//
//  Created by PandaPo on 20.03.25.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
    }
}
