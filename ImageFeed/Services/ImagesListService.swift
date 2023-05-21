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
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(_ token: String) {
        if task != nil {
            return
        }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        var request = URLRequest(url: DefaultBaseURL).photosRequest(page: nextPage, perPage: 10)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.task = nil
            case .success(let photosResult):
                self.task = nil
                DispatchQueue.main.async {
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
}
