//
//  OAuth2Servise.swift
//  ImageFeed
//
//  Created by PandaPo on 02.03.25.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let expiresIn: Int?
    let refreshToken: String
    let scope: String
    let tokenType: String
    let createdAt: Int
    let userId: Int
    let username: String
}

enum AuthServiceError: Error {
    case invalidRequest
    case networkError(Error)
    case httpError(Int)
    case noData
    case decodingError(Error)
    case missingToken
}

final class OAuth2Servise {
    
    static let shared = OAuth2Servise()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private var authToken: String?
    
    //MARK: - Request creating
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Ошибка: невозможно создать baseURL")
            return nil
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("Ошибка: невозможно создать URL для запроса")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    //MARK: - Fetch token
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            print("[fetchOAuthToken]: InvalidRequest - код уже использовался")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken]: InvalidRequest - не удалось создать URLRequest")
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let oAuthTokenResponseBody):
                    
                    self.authToken = oAuthTokenResponseBody.accessToken
                    OAuth2TokenStorage.shared.token = oAuthTokenResponseBody.accessToken
                    completion(.success(oAuthTokenResponseBody.accessToken))
                    
                case .failure(let error):
                    print("[fetchOAuthToken]: \(error.errorDescription())")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }
}
