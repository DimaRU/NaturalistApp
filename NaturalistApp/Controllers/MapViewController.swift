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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupScaleButtons()
        setupMapTypeControl()
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
    
    func setupMapView() {
        
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)    //  Send it under storyboard controls
        //Размер + положение на экране
        mapView.frame = self.view.bounds
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        mapView.delegate = self
        // Настройки карты
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.mapType = .hybrid
        
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view  = mapView.dequeueReusableAnnotationView(withIdentifier: "entry") as? MKPinAnnotationView
        
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
    
    @objc func tapButtonPlus() {
        
        let zoomLevel: Double = mapView.zoomLevel() + 1
        mapView.setCenterCoordinate(centerCoordinate: mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    @objc func tapButtonMinus() {
        
        let zoomLevel: Double = mapView.zoomLevel() - 1
        mapView.setCenterCoordinate(centerCoordinate: mapView.centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    
    func setupScaleButtons() {
        let buttonPlus = UIButton(type: .custom)
        buttonPlus.translatesAutoresizingMaskIntoConstraints = false
        
        buttonPlus.setImage(UIImage(named: "1474761840_add.png"), for: .normal)
        buttonPlus.addTarget(self, action: #selector(tapButtonPlus), for: .touchUpInside)
        
        self.view.addSubview(buttonPlus)
        
        //Trailing edge
        // Up center
        NSLayoutConstraint.activate([
            buttonPlus.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            buttonPlus.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25),
            buttonPlus.widthAnchor.constraint(equalToConstant: 35),
            buttonPlus.heightAnchor.constraint(equalToConstant: 35)
            ])

        let buttonMinus = UIButton(type: .custom)
        buttonMinus.translatesAutoresizingMaskIntoConstraints = false
        
        buttonMinus.setImage(UIImage(named: "1474761917_sub.png"), for: .normal)
        buttonMinus.addTarget(self, action: #selector(tapButtonMinus), for: .touchUpInside)
        
        self.view.addSubview(buttonMinus)
        
        //Trailing edge
        NSLayoutConstraint.activate([
            buttonMinus.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            buttonMinus.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25),
            buttonMinus.widthAnchor.constraint(equalToConstant: 35),
            buttonMinus.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    
    @objc func mapTypeCotrolChanged(sender:UISegmentedControl!)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .hybrid
        case 1:
            mapView.mapType = .satellite
        default:
            return
        }
    }
    
    func setupMapTypeControl() {
        let mapTypeCotrol = UISegmentedControl(items: ["Hybrid", "Sattelite"])
        
        mapTypeCotrol.selectedSegmentIndex = 0
        mapTypeCotrol.translatesAutoresizingMaskIntoConstraints = false
        
        mapTypeCotrol.addTarget(self, action: #selector(mapTypeCotrolChanged), for: .valueChanged)
        self.view.addSubview(mapTypeCotrol)
        
        NSLayoutConstraint.activate([
            mapTypeCotrol.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            mapTypeCotrol.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            ])
    }
    
}
