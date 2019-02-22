//
//  Geojson.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 22/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

enum Geojson {
    case point(lat: Double, lng: Double)
    case other(typeString: String, coordinates: [Double])
    
    enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
}

extension Geojson: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        let coords = try container.decode([String].self, forKey: .coordinates).compactMap{ Double($0) }
        
        if typeString == "Point" {
            guard coords.count == 2 else {
                throw DecodingError.dataCorruptedError(forKey: .coordinates,
                                                       in: container,
                                                       debugDescription: "Gejson point Type coordinates is't equal 2")
            }
            self = .point(lat: coords[0], lng: coords[1])
        } else {
            self = .other(typeString: typeString, coordinates: coords)
        }
    }
}

extension Geojson: Encodable {
    func encode(to encoder: Encoder) throws {
        fatalError("encode Geojson has not been implemented")
    }
    
}
