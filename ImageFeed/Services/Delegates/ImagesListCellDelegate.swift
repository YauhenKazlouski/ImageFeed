//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by PandaPo on 06.04.25.
//

import Foundation
protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
