/////
////  ObservationAnnotation.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import MapKit

final class ObservationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let id: ObservationId

    init(id: ObservationId, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.id = id
        super.init()
    }

    convenience init?(observation: Observation) {
        guard let coordinate = observation.coordinate else { return nil }
        self.init(id: observation.id, coordinate: coordinate)
    }
}
