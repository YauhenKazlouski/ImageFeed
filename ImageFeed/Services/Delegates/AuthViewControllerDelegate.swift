//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by PandaPo on 02.03.25.
//

import Foundation
protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
