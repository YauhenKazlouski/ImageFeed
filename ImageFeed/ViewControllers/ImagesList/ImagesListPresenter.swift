//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by PandaPo on 12.04.25.
//

import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
// MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var photosCount: Int {
        photos.count
    }
    
// MARK: - Private Properties
    private let imagesListService: ImagesListServiceProtocol
    private var photos: [Photo] = []
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
        
        setupNotificationObserver()
    }
    
// MARK: - Public Methods
    func viewDidLoad() {
        loadPhotos()
    }
    
    func photo(at index: Int) -> Photo? {
        guard index >= 0 && index < photos.count else { return nil }
        return photos[index]
    }
    
    func fetchPhotosNextPageIfNeeded() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(for photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            switch result {
            case .success:
                if let newPhoto = self?.imagesListService.photos.first(where: { $0.id == photoId }) {
                    if let index = self?.photos.firstIndex(where: { $0.id == photoId }) {
                        self?.photos[index] = newPhoto
                    }
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func calculateCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
// MARK: - Private Methods
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            view?.performBatchUpdates(oldCount: oldCount, newCount: newCount)
        }
    }
    
    private func loadPhotos() {
        UIBlocingProgressHUD.show()
        
        if imagesListService.photos.isEmpty {
            imagesListService.fetchPhotosNextPage()
            UIBlocingProgressHUD.dismiss()
        } else {
            photos = imagesListService.photos
            view?.updateTableViewAnimated()
            UIBlocingProgressHUD.dismiss()
        }
    }
}
