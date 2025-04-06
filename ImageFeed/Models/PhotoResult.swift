//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by PandaPo on 06.04.25.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}
