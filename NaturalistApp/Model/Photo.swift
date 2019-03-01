//
//  Photo.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias PhotoId = Int
struct Photo: Codable {
    struct OriginalDimensions: Codable {
        let width: Int
        let height: Int
    }
    
    let id: PhotoId
    let url: URL
    let originalDimensions: OriginalDimensions?
    let squareUrl: URL?
    let mediumUrl: URL?
    let smallUrl: URL?
    let largeUrl: URL?
    let originalUrl: URL?
    let attribution: String
    let licenseCode: String?
    let nativePageUrl: URL?
    let nativePhotoId: String?
    let type: String?
}
