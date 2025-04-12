//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by PandaPo on 12.04.25.
//
@testable import ImageFeed
import XCTest
import Kingfisher

final class ProfileViewTests: XCTestCase {
    
    var sut: ProfileViewController!
    var presenterMock: ProfilePresenterSpy!
    
    override func setUp() {
        super.setUp()
        sut = ProfileViewController()
        presenterMock = ProfilePresenterSpy()
        sut.presenter = presenterMock
        sut.loadViewIfNeeded() // Инициализируем view
    }
    
    override func tearDown() {
        sut = nil
        presenterMock = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsPresenter() {
        //When:
        sut.viewDidLoad()
        
        //Then:
        XCTAssertTrue(presenterMock.viewDidLoadCalled)
    }
    
    func testUpdateProfileDetails() {
            //Given:
            let testName = "Test Name"
            let testLogin = "@test"
            let testBio = "Test bio"
            
            //When:
            sut.updateProfileDetails(name: testName, loginName: testLogin, bio: testBio)
            
            //Then:
        let views = sut.testableViews()
            XCTAssertEqual(views.nameLabel.text, testName)
            XCTAssertEqual(views.loginNameLabel.text, testLogin)
            XCTAssertEqual(views.descriptionLabel.text, testBio)
        }
}

