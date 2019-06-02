/////
////  SLocation.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct SLocation {
    let lat: Double
    let lng: Double
}

extension SLocation: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let locationString = try container.decode(String.self)
        let coords = locationString.split(separator: ",").compactMap{ Double($0) }
        guard coords.count == 2 else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "StringLocation mailformed")
        }
        lat = coords[0]
        lng = coords[1]
    }
}
