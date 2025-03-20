//
//  ProfileResponseBody.swift
//  ImageFeed
//
//  Created by PandaPo on 20.03.25.
//

import Foundation
struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}
