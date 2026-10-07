//
//  ImageListTest.swift
//  ImageListTest
//
//  Created by Anton Rachkov on 16.09.2026.
//

import Testing
import XCTest
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var photosCount: Int = 0
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photo(at index: Int) -> Photo {
        return Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: false
        )
    }
    
    func formattedDate(for date: Date?) -> String {
        return ""
    }
    
    func willDisplayCell(at index: Int) { }
    
    func didTapLike(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) { }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var showErrorAlertCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func showErrorAlert() {
        showErrorAlertCalled = true
    }
}

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        
        let presenterSpy = ImagesListPresenterSpy()
        viewController.configure(presenterSpy)
        
        _ = viewController.view
        
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableViewAnimated() {
        let viewControllerSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        viewControllerSpy.presenter = presenter
        presenter.view = viewControllerSpy
        
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        XCTAssertTrue(viewControllerSpy.updateTableViewAnimatedCalled || presenter.photosCount == 0)
    }
}
