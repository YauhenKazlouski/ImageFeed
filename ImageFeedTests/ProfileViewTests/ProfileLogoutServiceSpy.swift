//
//  ProfileLogoutServiceSpy.swift
//  ImageFeedTests
//
//  Created by PandaPo on 12.04.25.
//
@testable import ImageFeed
import Foundation

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    var logoutCalled = false
    
    func logout() {
        logoutCalled = true
    }
}
