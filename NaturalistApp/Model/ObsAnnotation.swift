//
//  ObsAnnotation.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 25/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import MapKit

final class ObsAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let id: ObservationId

    init(id: ObservationId, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.id = id
        super.init()
    }
    

    convenience init?(observation: Observation) {
        let coordinate = CLLocationCoordinate2D(latitude: observation.location.lat,
                                                longitude: observation.location.lng)
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            return nil
        }
        self.init(id: observation.id, coordinate: coordinate)
    }
}
