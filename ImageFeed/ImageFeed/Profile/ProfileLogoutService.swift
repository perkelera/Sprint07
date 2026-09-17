//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Anton Rachkov on 28.08.2026.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        clearToken()
        clearServicesData()
        switchToSplashViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    private func clearToken () {
        OAuth2TokenStorage.shared.token = nil
    }
    private func clearServicesData() {
        ProfileService.shared.clearProfile()
        ProfileImageService.shared.clearAvatarURL()
        ImagesListService.shared.clearPhotos()
    }
    private func switchToSplashViewController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
        }
    }
}

