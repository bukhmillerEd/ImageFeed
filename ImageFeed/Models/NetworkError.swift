//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Эдуард Бухмиллер on 07.05.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
