//
//  Photo.swift
//  ImageFeed
//
//  Created by PandaPo on 06.04.25.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    var isValidLargeURL: Bool {
        !largeImageURL.isEmpty && URL(string: largeImageURL) != nil
    }
    var isValidThumbImageURL: Bool {
        !thumbImageURL.isEmpty && URL(string: thumbImageURL) != nil
    }
}
