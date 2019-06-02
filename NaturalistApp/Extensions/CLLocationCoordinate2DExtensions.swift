/////
////  CLLocationCoordinate2DExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
