//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by PandaPo on 20.03.25.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let expiresIn: Int?
    let refreshToken: String
    let scope: String
    let tokenType: String
    let createdAt: Int
    let userId: Int
    let username: String
}
