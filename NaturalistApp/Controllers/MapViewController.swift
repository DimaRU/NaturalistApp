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
    var observations: [ObservationId:Observation] = [:]
    var delayMapChangeTimer: Timer?

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

    private func fetchObservationsPage(page: Int, mapRect: MKMapRect) {
        let (swCoord, neCoord) = mapRect.iNatRegion()
        let target = NatAPI.getObservationsBox(page: page,
                                               nelat: neCoord.latitude,
                                               nelng: neCoord.longitude,
                                               swlat: swCoord.latitude,
                                               swlng: swCoord.longitude)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observation>) in
                print(pagedResult.page, pagedResult.perPage, pagedResult.totalResults)
                let observations = pagedResult.results.content
                self.addAnnotations(for: observations)
                guard self.mapView.visibleMapRect == mapRect else { return }
                let fetchedCount = (pagedResult.page - 1) * pagedResult.perPage + observations.count
                if fetchedCount >= pagedResult.totalResults || fetchedCount >= 100 { return }
                self.fetchObservationsPage(page: pagedResult.page + 1, mapRect: mapRect)
            }.ignoreErrors()
        
    }
    
    
    func addAnnotations(for observations: [Observation])  {
        guard !observations.isEmpty else { return }

        let annotationsToRemove = mapView.annotations.filter{ !mapView.visibleMapRect.contains(coordinate: $0.coordinate) }
        mapView.removeAnnotations(annotationsToRemove)
        
        let annotations = observations.compactMap { (observation) -> ObsAnnotation? in
            if self.observations.updateValue(observation, forKey: observation.id) == nil {
                return ObsAnnotation(observation: observation)
            } else {
                return nil
            }
        }
        mapView.addAnnotations(annotations)
        let freeIds = mapView.annotations.compactMap { ($0 as? ObsAnnotation)?.id }.filter { self.observations[$0] != nil }
        freeIds.forEach { self.observations.removeValue(forKey: $0) }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        guard let annotation = annotation as? ObsAnnotation else {
            return nil
        }
        
        let reuseIdentifier: String = "ObservationAnnotationMarkerReuseId"
        
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let observation = observations[annotation.id]
        let iconicTaxonName = observation?.taxon?.iconicTaxonName ?? IconicTaxonName.unknown
        view.image = UIImage(named: "Location")?.maskWith(color: iconicTaxonName.color)
        view.canShowCallout = false

        return view
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delayMapChangeTimer?.invalidate()
        
        delayMapChangeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            print("Start map change", self.mapView.visibleMapRect)
            self.fetchObservationsPage(page: 1, mapRect: self.mapView.visibleMapRect)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotation = view.annotation as? ObsAnnotation else { return }
        
        print("Selected: ", annotation.id)
    }
}
