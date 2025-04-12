//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by PandaPo on 12.04.25.
//
@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
    func updateAvatar() {}
    
    func updateProfilaDetails() {}
    
    
}
