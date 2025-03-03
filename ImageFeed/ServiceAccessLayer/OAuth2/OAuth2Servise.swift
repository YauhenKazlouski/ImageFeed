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

final class OAuth2Servise {
    
    static let shared = OAuth2Servise()
    private init() {}
    
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
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "RequestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Невозможно создать запрос"])))
            return
        }
        //сетевые ошибки:
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Сетевая ошибка: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
         // ошибки статусов ответа
            if let httpRespose = response as? HTTPURLResponse, httpRespose.statusCode >= 300 {
                let statusError = NSError(domain: "HTTPError",
                                          code: httpRespose.statusCode,
                                          userInfo: [NSLocalizedDescriptionKey: "Ошибка сервера: \(httpRespose.statusCode)"])
                print("Ошибка сервера: \(httpRespose.statusCode)")
                
                DispatchQueue.main.async {
                    completion(.failure(statusError))
                }
                return
            }
            
            guard let data else {
                let noDataError = NSError(domain: "No data",
                                          code: -1,
                                          userInfo: [NSLocalizedDescriptionKey: "Нет данных в ответе"])
                print("Ошибка: Нет данных в ответе")
                
                DispatchQueue.main.async {
                    completion(.failure(noDataError))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let oAuthTokenResponseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                self.authToken = oAuthTokenResponseBody.accessToken
                
                OAuth2TokenStorage.shared.token = oAuthTokenResponseBody.accessToken
                
                DispatchQueue.main.async {
                    completion(.success(oAuthTokenResponseBody.accessToken))
                }
            } catch {
                print("Ошибка декодирования: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
