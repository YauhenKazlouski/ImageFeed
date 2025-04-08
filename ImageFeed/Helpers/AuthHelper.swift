//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by PandaPo on 09.04.25.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    // MARK: - Public methods
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return  nil}
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    // MARK: - Private methods
    private func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else { return nil}
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        return urlComponents.url
    }
    
}
    
