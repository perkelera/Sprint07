//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Anton Rachkov on 16.09.2026.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func photo(at index: Int) -> Photo
    func formattedDate(for date: Date?) -> String
    func willDisplayCell(at index: Int)
    func didTapLike(at index: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showErrorAlert()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService: ImagesListService
    private var imagesListServiceObserver: NSObjectProtocol?
    private(set) var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var photosCount: Int {
        photos.count
    }
    
    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }
    
    deinit {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updatePhotos()
        }
        
        imagesListService.fetchPhotosNextPage()
    }
    
    func photo(at index: Int) -> Photo {
        photos[index]
    }
    
    func formattedDate(for date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func willDisplayCell(at index: Int) {
        if index + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func didTapLike(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let photo = photos[index]
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func updatePhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}
