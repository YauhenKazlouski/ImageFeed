//
//  Constants.swift
//  ImageFeed
//
//  Created by PandaPo on 18.02.25.
//

import Foundation
enum Constants{
    static let accessKey = "3WQdPgiZrCbS1yA1okine_luer-5hwHR1Wqe1nGPJZg"
    static let secretKey = "JV4lNtlCIfZxOtmqL4_a51R9y61Zr_Vin457Y5JCKUE"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Failed to create default base URL")
        }
        return url
    }
}
