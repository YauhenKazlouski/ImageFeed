//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 08.04.25.
//

import Foundation
public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
