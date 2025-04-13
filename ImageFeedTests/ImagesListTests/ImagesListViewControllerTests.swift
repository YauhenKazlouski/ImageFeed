//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by PandaPo on 13.04.25.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    
    var viewController: ImagesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        viewController = ImagesListViewControllerSpy()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsPresenter() {
        //Given:
        let presenter = ImagesListPresenterSpy()
        let sut = ImagesListViewController()
        sut.presenter = presenter
        
        //When:
        _ = sut.view
        
        //Then:
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testUpdateTableViewAnimated() {
        //When:
        viewController.updateTableViewAnimated()
        
        //Then:
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testPerformBatchUpdates() {
        //Given:
        let oldCount = 5
        let newCount = 10
        
        //When:
        viewController.performBatchUpdates(oldCount: oldCount, newCount: newCount)
        
        //Then:
        XCTAssertTrue(viewController.performBatchUpdatesCalled)
        XCTAssertEqual(viewController.oldCount, oldCount)
        XCTAssertEqual(viewController.newCount, newCount)
    }
    
    func testShowLikeAlert() {
        //Given:
        let testError = NSError(domain: "test", code: 123)
        
        //When:
        viewController.showLikeAlert(testError)
        
        //Then:
        XCTAssertTrue(viewController.showLikeAlertCalled)
        XCTAssertNotNil(viewController.likeError)
        XCTAssertEqual((viewController.likeError! as NSError).code, testError.code)
        XCTAssertEqual((viewController.likeError! as NSError).domain, testError.domain)
    }
    
    func testShowImageAlert() {
        //When:
        viewController.showImageAlert()
        
        //Then:
        XCTAssertTrue(viewController.showImageAlertCalled)
    }
    
}
