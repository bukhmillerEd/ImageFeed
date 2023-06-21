//
//  ProfileViewTest.swift
//  ImageFeedTests
//
//  Created by Эдуард Бухмиллер on 08.06.2023.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    private(set) var viewDidLoadDidCalled: Bool = false
    private(set) var removeUserDataDidCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadDidCalled = true
    }
    
    func removeUserData() {
        removeUserDataDidCalled = true
    }
}

final class ProfileViewTest: XCTestCase {

    func testViewControllerCallsViewDidLoad() {

        let vc = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        presenter.view = vc
        vc.presenter = presenter
        
        _ = vc.view
        
        XCTAssertTrue(presenter.viewDidLoadDidCalled)
    }
    
    func testViewControllereCallsUpdateProfileDetails() {
        let vc = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        presenter.view = vc
        vc.presenter = presenter
        
        presenter.removeUserData()
        
        XCTAssertTrue(presenter.removeUserDataDidCalled)
        
    }
    

}
