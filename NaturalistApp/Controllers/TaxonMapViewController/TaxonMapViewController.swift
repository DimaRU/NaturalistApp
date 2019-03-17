//
//  TaxonMapViewController.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 17/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

class TaxonMapViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var mapView: MKMapView!
    let reuseIdentifier: String = "ObservationAnnotationMarkerReuseId"

    var observationId: ObservationId?
    var observationCoordinate: CLLocationCoordinate2D?
    var taxon: Taxon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)

        getBoundingBox()
    }

    private func getBoundingBox() {
        NatProvider.shared.request(.searchTaxonBounds(id: taxon.id))
            .done { (result: PagedResults<Observation>) in
                self.setupMapView(mapBounds: result.totalBounds!)
            }.ignoreErrors()
    }
    
    private func setupMapView(mapBounds: MapBounds) {
        let sw = CLLocationCoordinate2D(latitude: mapBounds.swlat, longitude: mapBounds.swlng)
        let ne = CLLocationCoordinate2D(latitude: mapBounds.nelat, longitude: mapBounds.nelng)
        let p1 = MKMapPoint(sw)
        let p2 = MKMapPoint(ne)
        var mapRect = MKMapRect(x: fmin(p1.x,p2.x),
                                 y: fmin(p1.y,p2.y),
                                 width: fabs(p1.x-p2.x),
                                 height: fabs(p1.y-p2.y))
        
        let template = "https://tiles.inaturalist.org/v1/colored_heatmap/{z}/{x}/{y}.png?taxon_id=" + String(taxon.id)
        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.tileSize = CGSize(width: 512, height: 512)
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveLabels)
        
        if let coordinate = observationCoordinate {
            let obsPoint: MKMapPoint = MKMapPoint(coordinate)
            let obsCoordRect: MKMapRect = MKMapRect(x: obsPoint.x, y: obsPoint.y, width: 0.1, height: 0.1)
            mapRect = mapRect.union(obsCoordRect)
        }
        mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: false)

        if let observationId = observationId, let coordinate = observationCoordinate {
            let annotation = ObservationAnnotation(id: observationId, coordinate: coordinate)
            mapView.addAnnotation(annotation)
            if !mapView.visibleMapRect.contains(MKMapPoint(annotation.coordinate)) {
                mapView.centerCoordinate = annotation.coordinate
            }
        }
    }

}

extension TaxonMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MKTileOverlayRenderer(tileOverlay: overlay as! MKTileOverlay)
    }
    
    
    func mapView(_ map: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ObservationAnnotation else { return nil }
        
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        let iconicTaxonName = taxon.iconicTaxonName ?? IconicTaxonName.unknown
        let image = UIImage(named: "Location")!.maskWith(color: iconicTaxonName.color)
        view.image = image
        view.centerOffset = CGPoint(x: 0, y: image.size.height)
        view.canShowCallout = false
        return view
    }

}
