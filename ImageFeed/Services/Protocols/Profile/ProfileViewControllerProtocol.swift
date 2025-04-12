//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 12.04.25.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(name: String, loginName: String, bio: String)
    func updateAvatar(with url: URL)
    func showDefaultAvatar()
    func showLogoutAlert()
}
