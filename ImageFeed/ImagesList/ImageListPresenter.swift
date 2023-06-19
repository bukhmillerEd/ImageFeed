//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 06.06.2023.
//

import Foundation

protocol ImageListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func fetchPhotos()
    func dataLoaded()
}

final class ImageListPresenter: ImageListPresenterProtocol {
    
    private var dataModelImageList: ImageListModelProtocol?
    private weak var view: ImagesListViewControllerProtocol?
    private var imageListServiceObserver: NSObjectProtocol?
    
    init(dataModelImageList: ImageListModelProtocol, view: ImagesListViewControllerProtocol) {
        self.dataModelImageList = dataModelImageList
        self.view = view
    }
    
    func viewDidLoad() {
        addObserver()
        fetchPhotos()
    }
    
    func fetchPhotos() {
        dataModelImageList?.fetchData()
    }
    
    func dataLoaded() {
        view?.updateTableView(date: dataModelImageList?.photos ?? [])
    }
    
    private func addObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListModel.LoadedPhotosNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.dataLoaded()
        }
    }
    
}
