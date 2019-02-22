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
    let attribution: String
    let url: URL
    let originalDimensions: OriginalDimensions
    let squareUrl: URL?
    let mediumUrl: URL?
    let licenseCode: String?
}
