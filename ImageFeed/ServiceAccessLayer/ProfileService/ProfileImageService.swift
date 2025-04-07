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
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "/users/\(username)", relativeTo: Constants.defaultBaseURL) else {
            print("[makeProfileImageRequest]: Ошибка - невозможно создать URL для запроса")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethodsConstants.httpMethodGet
        request.setValue("Bearer \(token)", forHTTPHeaderField: HttpMethodsConstants.forHTTPHeaderField)
        return request
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !isFetching else {
            print("[fetchProfileImageURL]: FetchingInProgress - запрос уже выполняется")
            return
        }
        
        guard let token = tokenStorage.token else {
            print("[fetchProfileImageURL]: MissingToken - токен отсутствует")
            completion(.failure(AuthServiceError.invalidRequest))
            isFetching = false
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            print("[fetchProfileImageURL]: InvalidRequest - не удалось создать URLRequest")
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
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
                    print("[fetchProfileImageURL]: Ошибка - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func reset() {
        avatarURL = nil
        task?.cancel()
        task = nil
        isFetching = false
    }
}
