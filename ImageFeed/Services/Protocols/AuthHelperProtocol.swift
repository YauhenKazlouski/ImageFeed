//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 09.04.25.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
