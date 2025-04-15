//
//  ProfileImageServiceSpy.swift
//  ImageFeedTests
//
//  Created by PandaPo on 12.04.25.
//
@testable import ImageFeed
import Foundation
final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    init(avatarURL: String? = nil) {
        self.avatarURL = avatarURL
    }
}
