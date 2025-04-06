//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by PandaPo on 06.04.25.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let perPage = 10
    private let dateFormatter = ISO8601DateFormatter()
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var isFetching: Bool = false
    
    private func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let token = oAuth2TokenStorage.token else {
            print("[makePhotosRequest]: MissingToken - токен отсутствует")
            return nil
        }
        
        guard let baseURL = Constants.defaultBaseURL else {
            print("[makeProfileRequest]: Ошибка - baseURL отсутствует")
            return nil
        }
        
        let photoPath = baseURL.appendingPathComponent("/photos")
        
        var components = URLComponents(url: photoPath, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = components?.url else {
            print("[makeProfileRequest]: Ошибка - Невозможно создать URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage() {
        guard !isFetching else {
            print("[fetchPhotosNextPage]: FetchingInProgress - запрос уже выполняется")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage, perPage: perPage) else {
            print("[fetchPhotosNextPage]: InvalidRequest - не удалось создать URLRequest")
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            assert(Thread.isMainThread)
            
            guard let self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let photoResult):
                let newPhotos = photoResult.map { photoResult in
                    Photo(id: photoResult.id,
                          size: CGSize(width: photoResult.width, height: photoResult.height),
                          createAt: self.dateFormatter.date(from: photoResult.createdAt),
                          welcomeDescription: photoResult.description,
                          thumbImageURL: photoResult.urls.thumb,
                          largeImageURL: photoResult.urls.full,
                          isLiked: photoResult.likedByUser)
                }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
                
            case .failure(let error):
                print("[fetchPhotosNextPage]: Ошибка - \(error.localizedDescription)")
            }
        }
        
        self.task = task
        task.resume()
    }
    
}
