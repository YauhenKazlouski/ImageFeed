//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by PandaPo on 17.03.25.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private let tokenStorage = OAuth2TokenStorage.shared
    private(set) var avatarURL: String?
    private var isFetching: Bool = false
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !isFetching else {
            print("[fetchProfileImageURL]: Ошибка - Запрос уже выполняется")
            return
        }
        
        guard let token = tokenStorage.token else {
            print("[fetchProfileImageURL]: Ошибка - отсутствует токен")
            completion(.failure(AuthServiceError.invalidRequest))
            isFetching = false
            return
        }
        
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "/users/\(encodedUsername)", relativeTo: Constants.defaultBaseURL) else {
            print("[fetchProfileImageURL]: Ошибка - неверный URL")
            completion(.failure(AuthServiceError.invalidRequest))
            isFetching = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        isFetching = true
        task?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isFetching = false
                
                switch result {
                case .success(let userResult):
                    guard let profileImage = userResult.profileImage else {
                        print("[fetchProfileImageURL]: NoData - отсутствует URL аватара")
                        completion(.failure(AuthServiceError.noData))
                        return
                    }
                    
                    self.avatarURL = profileImage.large
                    completion(.success(profileImage.large))
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImage.large]
                    )
                case .failure(let error):
                    print("[fetchProfileImageURL]: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}
