//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by PandaPo on 17.03.25.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
    }
}



final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private (set) var avatarURL: String?
    private var isFetching: Bool = false
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        let urlString = "https://api.unsplash.com/users/\(username)"
        
        guard let url = URL(string: urlString) else {
            print("Ошибка: неверный URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard !isFetching else {
            print("Предупреждение: запрос уже выполняется")
            return
        }
        
        guard let token = oAuth2TokenStorage.token else {
            print("Ошибка: токен отсутствует")
            completion(.failure(AuthServiceError.missingToken))
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isFetching = false
                
                switch result {
                case .success(let userResult):
                    guard let profileImageURL = userResult.profileImage?.small else {
                        completion(.failure(AuthServiceError.noData))
                        return
                    }
                    
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL])
                    
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    
                case .failure(let error):
                    print("Ошибка: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}
