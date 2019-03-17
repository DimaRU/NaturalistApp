//
//  ObservationCoordinate.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation
import MapKit

extension Observation {
    var coordinate: CLLocationCoordinate2D? {
        guard let location = location else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: location.lat,
                                                longitude: location.lng)
        guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }
        return coordinate
    }
}
