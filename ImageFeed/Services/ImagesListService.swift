//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 20.05.2023.
//

import Foundation

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let token = OAuth2TokenStorage.shared.token
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(_ token: String) {
        if task != nil {
            return
        }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        var request = URLRequest(url: DefaultBaseURL).photosRequest(page: nextPage, perPage: 10)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.task = nil
                case .success(let photosResult):
                    self.task = nil
                    self.lastLoadedPage = nextPage
                    for photoResult in photosResult {
                        self.photos.append(Photo(photoResult: photoResult))
                    }
                    NotificationCenter.default.post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos])
                }
                
            }
            
        }
        task?.resume()
        task = nil
    }
    
    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<LikePhotoResult, Error>) -> Void) {
        guard let token else { return }
        var request: URLRequest
        request = URLRequest(url: DefaultBaseURL).likeRequest(photoId: photoId, isLike: isLike)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<LikePhotoResult, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let likePhotoResult):
                completion(.success(likePhotoResult))
            }
        }
        task.resume()
    }
    
}
