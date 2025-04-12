//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by PandaPo on 12.04.25.
//

import Foundation
protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated()
    func performBatchUpdates(oldCount: Int, newCount: Int)
    func showLikeAlert(_ error: Error)
    func showImageAlert()
}
