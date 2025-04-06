//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by PandaPo on 06.04.25.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
