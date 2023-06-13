//
//  ImageListViewTest.swift
//  ImageFeedTests
//
//  Created by Эдуард Бухмиллер on 09.06.2023.
//

import XCTest
@testable import ImageFeed

let mockphotos: [Photo] = Array(0..<20).map{
    Photo(photoResult: PhotoResult(id: "\($0)",
                                   createdAt: "",
                                   description: "",
                                   likedByUser: false,
                                   width: 10,
                                   height: 20,
                                   urls: PhotoResult.UrlsResult(raw: "",
                                                                full: "",
                                                                regular: "",
                                                                small: "",
                                                                thumb: ""))
    )
    
    
}

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    private(set) var viewDidLoadDidCalled = false
    func viewDidLoad() {
        viewDidLoadDidCalled = true
    }
    
    func fetchPhotos() {
    }
    
    func dataLoaded() {
    }
}

final class ImageListModelSpy: ImageListModelProtocol {
    var photos: [ImageFeed.Photo] = []
    
    func fetchData() {
        self.photos = mockphotos
    }
    
    
}

final class ImageListViewTest: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ImageListVC") as! ImagesListViewController
        
        var presenter = ImageListPresenterSpy()
        
        vc.presenter = presenter
       
        vc.viewDidLoad()
        
        XCTAssertTrue(presenter.viewDidLoadDidCalled)
    }
    
    func  testFetchData() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ImageListVC") as! ImagesListViewController
        
        let modelSpy = ImageListModelSpy()
        var presenter = ImageListPresenter(dataModelImageList: modelSpy, view: vc)
        
        vc.presenter = presenter
       
        vc.viewDidLoad()
        
        XCTAssertEqual(modelSpy.photos.count, mockphotos.count)
        
    }
    
    
}
