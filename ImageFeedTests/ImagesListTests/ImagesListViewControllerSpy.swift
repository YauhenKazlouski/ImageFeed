//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by PandaPo on 13.04.25.
//
@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewAnimatedCalled = false
    var performBatchUpdatesCalled = false
    var showLikeAlertCalled = false
    var showImageAlertCalled = false
    
    var likeError: Error?
    var oldCount: Int?
    var newCount: Int?
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func performBatchUpdates(oldCount: Int, newCount: Int) {
        performBatchUpdatesCalled = true
        self.oldCount = oldCount
        self.newCount = newCount
    }
    
    func showLikeAlert(_ error: any Error) {
        showLikeAlertCalled = true
        likeError = error
    }
    
    func showImageAlert() {
        showImageAlertCalled = true
    }
}
