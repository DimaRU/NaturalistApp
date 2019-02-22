//
//  MapViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 18/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var observations: [Observation] = []
    var delayMapChangeTimer: Timer?
    var fetchPage = 0
    var exploreRegion: ExploreRegion?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CLLocationManager.requestAuthorization(type: .whenInUse)
            .then { _ in
                CLLocationManager.requestLocation()
            }.done { location in
                print(location)
            }.ignoreErrors()
   }

    @IBAction func tapButtonPlus(_ sender: UIButton) {
        let zoomLevel = mapView.zoomLevel + 1
        mapView.setCenterCoordinate(centerCoordinate: mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    @IBAction func tapButtonMinus(_ sender: UIButton) {
        let zoomLevel = mapView.zoomLevel - 1
        mapView.setCenterCoordinate(centerCoordinate: mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    @IBAction func tapButtonCenter(_ sender: UIButton) {
        CLLocationManager.requestAuthorization(type: .whenInUse)
            .then { _ in
                CLLocationManager.requestLocation()
            }.done { location in
                self.mapView.setCenter(location.last!.coordinate, animated: true)
            }.ignoreErrors()
        
    }
    
    @IBAction func mapTypeChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .hybrid
        case 1:
            mapView.mapType = .satellite
        default:
            return
        }
    }

    private func fetchObservationsPage(region: ExploreRegion) {
        guard let region = exploreRegion else { return }
        let target = NatAPI.getObservationsBox(page: fetchPage,
                                               nelat: region.neCoord.latitude,
                                               nelng: region.neCoord.longitude,
                                               swlat: region.swCoord.latitude,
                                               swlng: region.swCoord.longitude)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observation>) in
                let observations = pagedResult.results.content
                self.addAnnotations(observations)
            }.ignoreErrors()
        
    }
    
    
    func addAnnotations(_ observations: [Observation])  {
        guard !observations.isEmpty else { return }
//        mapView.removeAnnotations(mapView.annotations)
        
        for observation in observations {
            let coordinate = CLLocationCoordinate2D(latitude: observation.location.lat,
                                                    longitude: observation.location.lng)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let AnnotationIdentifier: String = "ObservationAnnotation"
        if annotation is MKUserLocation { return nil }
        
        let view = (mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationIdentifier) as? MKMarkerAnnotationView) ??
            MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier)
        
//        view.annotation = annotation
        view.canShowCallout = true
        view.glyphTintColor = UIColor.green

        return view
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delayMapChangeTimer?.invalidate()
        
        delayMapChangeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            print("Start map change")
            self.fetchPage = 1
            self.exploreRegion = ExploreRegion(mapRect: self.mapView.visibleMapRect)
            self.fetchObservationsPage(region: self.exploreRegion!)
        }
    }
}
