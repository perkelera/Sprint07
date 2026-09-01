//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Anton Rachkov on 12.08.2026.
//

import Foundation
import UIKit


struct UserResult: Codable {
    let profileImage: ProfileImage
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
struct ProfileImage: Codable {
    let small: String
}
final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue:"ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUsername: String?
    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)")
        else {
            return nil
        }
        
        guard let token = OAuth2TokenStorage.shared.token else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            if lastUsername != username {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastUsername == username {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        lastUsername = username
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.small
                self?.avatarURL = avatarURL
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                completion(.success(avatarURL))
            case .failure(let error):
                print("ProfileImage network error: \(error)")
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastUsername = nil
        }
        
        self.task = task
        task.resume()
    }
}

