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

class MapViewController: BasicViewController {
    let reuseIdentifier: String = "ObservationAnnotationMarkerReuseId"

    @IBOutlet weak var mapView: MKMapView!
    var observations: [ObservationId:Observation] = [:]
    var delayMapChangeTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
        
        setCurrentLocation()
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
        setCurrentLocation()
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
    
    private func setCurrentLocation() {
        CLLocationManager.requestAuthorization(type: .whenInUse)
            .then { _ in
                CLLocationManager.requestLocation()
            }.done { location in
                self.mapView.setCenterCoordinate(centerCoordinate: location.last!.coordinate, zoomLevel: 14, animated: true)
            }.ignoreErrors()
    }

    private func fetchObservationsPage(page: Int, mapRect: MKMapRect) {
        let (swCoord, neCoord) = mapRect.iNatRegion()
        let target = NatAPI.getObservationsBox(perPage: 20,
                                               page: page,
                                               nelat: neCoord.latitude,
                                               nelng: neCoord.longitude,
                                               swlat: swCoord.latitude,
                                               swlng: swCoord.longitude)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observation>) in
//                print(pagedResult.page, pagedResult.perPage, pagedResult.totalResults)
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
        let annotationsToRemove = mapView.annotations.filter{
            ($0 is ObservationAnnotation) && !mapView.visibleMapRect.contains(coordinate: $0.coordinate) }
        mapView.removeAnnotations(annotationsToRemove)
        
        let annotations = observations.compactMap { (observation) -> ObservationAnnotation? in
            if self.observations.updateValue(observation, forKey: observation.id) == nil {
                return ObservationAnnotation(observation: observation)
            } else {
                return nil
            }
        }
        mapView.addAnnotations(annotations)
        let usedIds = Set<ObservationId>(mapView.annotations.compactMap { ($0 as? ObservationAnnotation)?.id })
        self.observations.keys.forEach{
            if !usedIds.contains($0) {
                self.observations.removeValue(forKey: $0)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ObservationAnnotation else { return nil }
        
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        let observation = observations[annotation.id]
        let iconicTaxonName = observation?.taxon?.iconicTaxonName ?? IconicTaxonName.unknown
        let image = UIImage(named: "Location")!.maskWith(color: iconicTaxonName.color)
        view.image = image
        view.centerOffset = CGPoint(x: 0, y: image.size.height)
        view.canShowCallout = false
        return view
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delayMapChangeTimer?.invalidate()
        
        delayMapChangeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            // Start map change
            self.fetchObservationsPage(page: 1, mapRect: self.mapView.visibleMapRect)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? ObservationAnnotation else { return }
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        let vc = ObservationDetailsViewController()
        vc.observation = self.observations[annotation.id]
        navigationController?.pushViewController(vc, animated: true)
    }
}
