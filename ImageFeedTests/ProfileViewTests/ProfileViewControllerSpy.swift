//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by PandaPo on 12.04.25.
//
@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var showDefaultAvatarCalled = false
    var showLogoutAlertCalled = false
    
    var name: String?
    var loginName: String?
    var bio: String?
    var avatarURL: URL?
    
    func updateProfileDetails(name: String, loginName: String, bio: String) {
        updateProfileDetailsCalled = true
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
        self.avatarURL = url
    }
    
    func showDefaultAvatar() {
        showDefaultAvatarCalled = true
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
    
    
}
