//
//  MapViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 18/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        entries = Entry.loadEntries()
        addAnnotations()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupScaleButtons()
        setupMapTypeControl()
    }
    
    func setupMapView() {
        
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)    //  Send it under storyboard controls
        //Размер + положение на экране
        mapView.frame = self.view.bounds
        //shortest way | old-school
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        mapView.delegate = self
        // Настройки карты
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.mapType = .standard
        
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

        buttonPlus.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        buttonPlus.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        buttonPlus.widthAnchor.constraint(equalToConstant: 35)
        buttonPlus.heightAnchor.constraint(equalToConstant: 35)

        let buttonMinus = UIButton(type: .custom)
        buttonMinus.translatesAutoresizingMaskIntoConstraints = false
        
        buttonMinus.setImage(UIImage(named: "1474761917_sub.png"), for: .normal)
        buttonMinus.addTarget(self, action: #selector(tapButtonMinus), for: .touchUpInside)
        
        self.view.addSubview(buttonMinus)
        
        //Trailing edge
        buttonMinus.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        buttonMinus.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        buttonMinus.widthAnchor.constraint(equalToConstant: 35)
        buttonMinus.heightAnchor.constraint(equalToConstant: 35)
    }
    
    @objc func mapTypeCotrolChanged(sender:UISegmentedControl!)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            return
        }
    }
    
    func setupMapTypeControl() {
        
        let mapTypeCotrol = UISegmentedControl(items: ["Map", "Hybrid", "Sattelite"])
        
        mapTypeCotrol.tintColor = UIColor.black
        mapTypeCotrol.selectedSegmentIndex = 0
        mapTypeCotrol.translatesAutoresizingMaskIntoConstraints = false
        
        mapTypeCotrol.addTarget(self, action: #selector(mapTypeCotrolChanged), for: .valueChanged)
        self.view.addSubview(mapTypeCotrol)
        
        mapTypeCotrol.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8)
        mapTypeCotrol.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
}
