//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by PandaPo on 20.03.25.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
