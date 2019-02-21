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
            }.catch { error in
                print(error)
        }
        //        entries = Entry.loadEntries()
        addAnnotations()
    }

    @IBAction func tapButtonPlus(_ sender: UIButton) {
        
        let zoomLevel = mapView.zoomLevel() + 1
        mapView.setCenterCoordinate(centerCoordinate: mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    @IBAction func tapButtonMinus(_ sender: UIButton) {
        
        let zoomLevel = mapView.zoomLevel() - 1
        mapView.setCenterCoordinate(centerCoordinate: mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
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

    
    func addAnnotations()  {
        mapView.removeAnnotations(mapView.annotations)
        
//        for entry in entries {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: entry.venue.latitude, longitude: entry.venue.longitude)
//            annotation.title = "\(entry.category) for \(entry.amount)р"
//            annotation.subtitle = entry.venue.name
//
//            mapView.addAnnotation(annotation)
//        }
//
//        if let entry = entries.first {
//            let center = CLLocationCoordinate2D(latitude: entry.venue.latitude, longitude: entry.venue.longitude)
//            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            let region = MKCoordinateRegion(center: center, span: span)
//            mapView.region = region
//
//            //mapView.showAnnotations([], animated: <#T##Bool#>)
//        }
        
    }
    
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "entry") as? MKPinAnnotationView

        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "entry")
        } else {
            view!.annotation = annotation
        }

        view!.canShowCallout = true
        view!.pinTintColor = UIColor.green
        view!.animatesDrop = true

        return view!

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.visibleMapRect)
        let exploreRegion = ExploreRegion(mapRect: mapView.visibleMapRect)
        print(exploreRegion)
    }
}
