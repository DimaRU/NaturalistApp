/////
////  EditLocationViewController.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import PromiseKit

protocol EditLocationViewControllerProtocol {
    func setLocation(coordinate: CLLocationCoordinate2D, positionalAccuracy: Double)
}
class EditLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    private let crossHairView = CrossHairView()
    private let accuracyCircleView = AccuracyCircleView()

    public var currentLocation: CLLocationCoordinate2D?
    public var positionalAccuracy: Double?
    public var delegate: EditLocationViewControllerProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(crossHairView)
        view.addSubview(accuracyCircleView)
        setCurrentLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        crossHairView.frame = view.frame
        accuracyCircleView.frame = view.frame
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func tapDoneButton(_ sender: Any) {
        delegate?.setLocation(coordinate: currentLocation!, positionalAccuracy: positionalAccuracy!)
        navigationController?.popViewController(animated: true)
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
        if let currentLocation = currentLocation, CLLocationCoordinate2DIsValid(currentLocation) {
            mapView.setCenter(currentLocation, animated: false)
            var region = MKCoordinateRegion()
            region.center = currentLocation

            let meters: Double
            if let positionalAccuracy = positionalAccuracy {
                meters = max(positionalAccuracy, 20)
            } else {
                meters = 500
                positionalAccuracy = meters
            }

            let accuracyInDegrees = metersToDegrees(meters)
            region.span.latitudeDelta = CLLocationDegrees(accuracyInDegrees * 5)
            region.span.longitudeDelta = CLLocationDegrees(accuracyInDegrees * 5)
            mapView.setRegion(mapView.regionThatFits(region), animated: false)
            
        } else {
            // null island
            let region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(0, 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
            mapView.setRegion(region, animated: false)
        }
        crossHairView.show(coordinate: mapView.centerCoordinate)
        accuracyCircleView.set(accuracy: positionalAccuracy!, radius: metersToPixels(positionalAccuracy!))

        CLLocationManager.requestAuthorization(type: .whenInUse)
            .then { _ in
                CLLocationManager.requestLocation()
            }.done { location in
            }.ignoreErrors()
    }

    func degreesToMeters(_ degrees: Double) -> Double {
        let planetaryRadius: Double = 6370997.0
        return degrees * 2 * .pi * planetaryRadius / 360.0
    }

    func metersToDegrees(_ meters: Double) -> Double {
        let planetaryRadius: Double = 6370997.0
        return meters * 360.0 / (2 * .pi * planetaryRadius)
    }

    func metersToPixels(_ meters: Double) -> CGFloat {
        let degrees = metersToDegrees(meters)
        let coord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude  + degrees)
        let newPt = mapView.convert(coord, toPointTo: mapView)
        return abs(mapView.center.x - newPt.x)
    }

    func pixelsToMeters(_ pixels: CGFloat) -> Double {
        let coord = mapView.convert(CGPoint(x: mapView.center.x + pixels, y: mapView.center.y), toCoordinateFrom: mapView)
        let distanceInDegrees = abs(coord.longitude - mapView.centerCoordinate.longitude)
        let distanceInMeters = degreesToMeters(distanceInDegrees)
        return distanceInMeters
    }

    func resetAccuracy() {
        let size = view.frame.size
        let pixelAcc = min(size.width, size.height) / 5
        positionalAccuracy = pixelsToMeters(pixelAcc)
    }
}

extension EditLocationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        currentLocation = mapView.centerCoordinate
        crossHairView.show(coordinate: currentLocation!)
        resetAccuracy()
        accuracyCircleView.set(accuracy: positionalAccuracy!, radius: metersToPixels(positionalAccuracy!))
    }
}
