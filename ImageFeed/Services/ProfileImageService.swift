//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 08.05.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: String?
    
    private var task: URLSessionTask?
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        var request = URLRequest(url: DefaultBaseURL).profileImageURLRequest(username: username)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let userResult):
                completion(.success(userResult.profileImage.small))
                self?.avatarURL = userResult.profileImage.small
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self?.avatarURL ?? ""])
                }
            }
        })
        task?.resume()
    }
    
}

