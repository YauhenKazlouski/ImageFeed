//
//  ProfileService.swift
//  ImageFeed
//
//  Created by PandaPo on 16.03.25.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private let oAuthTokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    private var isFetching: Bool = false
    
    func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print("[makeProfileRequest]: InvalidURL - неверный URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard !isFetching else {
            print("[fetchProfile]: FetchingInProgress - запрос уже выполняется")
            return
        }
        
        guard let token = oAuthTokenStorage.token else {
            print("[fetchProfile]: MissingToken - токен отсутствует")
            completion(.failure(AuthServiceError.missingToken))
            return
        }
        
        guard let request = makeProfileRequest(token: token) else {
            print("[fetchProfile]: InvalidRequest - не удалось создать URLRequest")
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isFetching = false
                
                switch result {
                case .success(let profileResult):
                    let profile = Profile(
                        username: profileResult.username,
                        name: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines),
                        loginName: "@\(profileResult.username)",
                        bio: profileResult.bio)
                    
                    self.profile = profile
                    completion(.success(profile))
                    
                case .failure(let error):
                    print("[fetchProfile]: \(error.errorDescription())")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}
