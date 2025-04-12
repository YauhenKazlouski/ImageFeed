//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 12.04.25.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didTapLogoutButton()
    func updateAvatar()
    func updateProfilaDetails()
}
