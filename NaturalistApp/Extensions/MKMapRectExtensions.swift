/////
////  MKMapRectExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import MapKit

extension MKMapRect {
    public func iNatRegion() -> (swCoord: CLLocationCoordinate2D, neCoord: CLLocationCoordinate2D) {
        let swCoord = MKMapPoint(x: self.origin.x, y: self.origin.y + self.size.height).coordinate
        let neCoord = MKMapPoint(x: self.origin.x + self.size.width, y: self.origin.y).coordinate
        return (swCoord, neCoord)
    }
    
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let point = MKMapPoint(coordinate)
        return self.contains(point)
    }
}

extension MKMapRect: Equatable {
    public static func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
        return MKMapRectEqualToRect(lhs, rhs)
    }
}
