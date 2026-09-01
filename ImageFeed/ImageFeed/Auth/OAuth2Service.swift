//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anton Rachkov on 31.07.2026.
//
import Foundation
enum AuthServiceError: Error {
    case invalidRequest
}
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private init() {}
    private var task : URLSessionTask?
    private var lastCode: String?
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                OAuth2TokenStorage.shared.token = response.accessToken
                completion(.success(response.accessToken))
            case .failure(let error):
                print("Authorization error: \(error)")
                completion(.failure(error))
            }
            self?.task = nil
            self?.lastCode = nil
            
        }
        
        self.task = task
        task.resume()
    }
}
