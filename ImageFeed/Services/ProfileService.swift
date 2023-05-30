//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 07.05.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile? 
    private let token = OAuth2TokenStorage.shared.token
    
    private var task: URLSessionTask?
    
    private init(){}
    
    func fetchProfile(completion: @escaping(Result<ProfileResult, Error>) -> Void) {
        guard let token else { return }
        task?.cancel()
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let profileResult):
                self?.profile = Profile(model: profileResult)
                completion(.success(profileResult))
            }
        })
        task?.resume()
    }
}
