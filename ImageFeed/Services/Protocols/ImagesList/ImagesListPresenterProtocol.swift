//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 12.04.25.
//

import Foundation
protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var dateFormatter: DateFormatter {get set}
    func viewDidLoad()
    func fetchPhotosNextPageIfNeeded()
    func changeLike(for photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func photo(at index: Int) -> Photo?
    var photosCount: Int { get }
    func calculateCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat
}
