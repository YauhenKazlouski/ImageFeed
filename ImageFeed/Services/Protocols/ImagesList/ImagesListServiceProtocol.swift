//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 12.04.25.
//

import Foundation
protocol ImagesListServiceProtocol: AnyObject {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    static var didChangeNotification: Notification.Name { get }
}
