//
//  ProfileServiceSpy.swift
//  ImageFeedTests
//
//  Created by PandaPo on 12.04.25.
//
@testable import ImageFeed
import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: ImageFeed.Profile?
    
    init(profile: ImageFeed.Profile? = nil) {
        self.profile = profile
    }
}
