//
//  ProfileViewTest.swift
//  ProfileViewTest
//
//  Created by Anton Rachkov on 16.09.2026.
//

import Testing
import XCTest

@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var didConfirmLogoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
    func didConfirmLogout() {
        didConfirmLogoutCalled = true
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var showLogoutAlertCalled = false
    
    func updateProfileDetails(name: String, loginName: String, bio: String) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        viewController.configure(presenterSpy)
        
        _ = viewController.view
        
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsShowLogoutAlert() {
        let viewControllerSpy = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewControllerSpy.presenter = presenter
        presenter.view = viewControllerSpy
        
        presenter.didTapLogoutButton()
        
        XCTAssertTrue(viewControllerSpy.showLogoutAlertCalled)
    }
}
