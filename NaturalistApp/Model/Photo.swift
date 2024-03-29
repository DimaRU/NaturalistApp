/////
////  Photo.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
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
    let attribution: String
    let licenseCode: String?
    let nativePageUrl: URL?
    let nativePhotoId: String?
    let type: String?
}

extension Photo {
    func replaceUrl(_ with: String) -> URL {
        let urlString = url.absoluteString.replacingOccurrences(of: "square", with: with)
        return URL(string: urlString)!
    }

    var squareUrl: URL { return self.url }
    var mediumUrl: URL { return replaceUrl("medium") }
    var smallUrl: URL { return replaceUrl("small") }
    var thumbUrl: URL { return replaceUrl("thumb") }
    var largeUrl: URL { return replaceUrl("large") }
    var originalUrl: URL { return replaceUrl("original") }

}
