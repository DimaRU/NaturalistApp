//
//  ExploreRegion.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 21/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import MapKit

struct ExploreRegion: CustomStringConvertible {
    let swCoord: CLLocationCoordinate2D     // South West
    let neCoord: CLLocationCoordinate2D     // North East
    
    init(mapRect: MKMapRect) {
        swCoord = MKMapPoint(x: mapRect.origin.x, y: mapRect.origin.y + mapRect.size.height).coordinate
        neCoord = MKMapPoint(x: mapRect.origin.x + mapRect.size.width, y: mapRect.origin.y).coordinate
    }
    
    var description: String {
        return "ExploreRegion SW: \(swCoord.latitude),\(swCoord.longitude) NE: \(neCoord.latitude),\(neCoord.longitude)"
    }
}
