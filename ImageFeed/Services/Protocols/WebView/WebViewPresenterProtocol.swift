//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 08.04.25.
//

import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set}
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
