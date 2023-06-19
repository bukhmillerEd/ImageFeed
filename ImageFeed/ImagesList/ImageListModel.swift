//
//  ImageListModel.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 07.06.2023.
//

import Foundation

protocol ImageListModelProtocol: AnyObject {
    var photos: [Photo] { get }
    func fetchData()
}

final class ImageListModel: ImageListModelProtocol {
    
    private(set) var photos: [Photo] = []
    private let imagesListService = ImagesListService()
    private var imageListServiceObserver: NSObjectProtocol?
    static let LoadedPhotosNotification = Notification.Name(rawValue: "LoadedPhotos")
    
    init() {
        addObserver()
    }
    
    func fetchData() {
        imagesListService.fetchPhotosNextPage()
    }
    
    private func addObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.photos = self.imagesListService.photos
            NotificationCenter.default.post(
                name: ImageListModel.LoadedPhotosNotification,
                object: self,
                userInfo: ["photos": self.photos])
        }
    }
    
}
