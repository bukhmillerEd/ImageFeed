//
//  ImageListCellModel.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 08.06.2023.
//

import Foundation

struct ImagesListCellModel {
    let photoName: String
    let date: String
    let favoritesName: String
    var completion: (() -> Void)
}
