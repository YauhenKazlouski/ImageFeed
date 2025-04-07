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
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        let dateFormatter = ISO8601DateFormatter()
        self.createAt = dateFormatter.date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
}
