//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by PandaPo on 01.03.25.
//

import Foundation
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
