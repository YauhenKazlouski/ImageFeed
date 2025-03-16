//
//  ProfileService.swift
//  ImageFeed
//
//  Created by PandaPo on 16.03.25.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let username: String
    let firstName: String
    let lastName: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.firstName = profileResult.firstName
        self.lastName = profileResult.lastName
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
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
            print("Ошибка: неверный URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard !isFetching else {
            print("Предупреждение: запрос уже выполняется")
            return
        }
        
        guard let token = oAuthTokenStorage.token else {
            print("Ошибка: Токен отсутствует")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        guard let response = makeProfileRequest(token: token) else {
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = URLSession.shared.data(for: response) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isFetching = false
                
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let profileResult = try decoder.decode(ProfileResult.self, from: data)
                        let profile = Profile(from: profileResult)
                        self.profile = profile
                        
                        completion(.success(profile))
                    } catch {
                        print("Ошибка декодирования: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
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
