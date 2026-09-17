//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Anton Rachkov on 16.09.2026.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
    func didConfirmLogout()
}

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(name: String, loginName: String, bio: String)
    func updateAvatar(url: URL)
    func showLogoutAlert()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let profileLogoutService: ProfileLogoutService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        profileLogoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func viewDidLoad() {
        setupProfileData()
        updateAvatarData()
        addObserver()
    }
    
    func didTapLogoutButton() {
        view?.showLogoutAlert()
    }
    
    func didConfirmLogout() {
        profileLogoutService.logout()
    }
    
    private func setupProfileData() {
        guard let profile = profileService.profile else { return }
        
        let name = (profile.name?.isEmpty ?? true) ? "Имя не указано" : (profile.name ?? "")
        let loginName = (profile.loginName?.isEmpty ?? true) ? "@неизвестный_пользователь" : (profile.loginName ?? "")
        let bio = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : (profile.bio ?? "")
        
        view?.updateProfileDetails(name: name, loginName: loginName, bio: bio)
    }
    
    private func updateAvatarData() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        
        view?.updateAvatar(url: imageUrl)
    }
    
    private func addObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatarData()
        }
    }
}
