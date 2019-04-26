//
//  AddObservationTableViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 15/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import PromiseKit

class AddObservationTableViewController: UITableViewController {

    @IBOutlet weak var taxaCell: TaxaTableViewCell!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var geoPrivacyCell: TitleValueTableViewCell!
    @IBOutlet weak var captiveCell: TitleValueTableViewCell!
    
    public var mainAsset: PHAsset? {
        didSet {
            setLocation(mainAsset?.location)
            observedOn = mainAsset?.creationDate ?? Date()
        }
    }
    public var taxon: Taxon?
    private var placeGuess: String?

    enum ChooseBool: String, CaseIterable, Localizable {
        case no, yes
        var localized: String {
            switch self {
            case .no:  return NSLocalizedString("No", comment: "Yes/No")
            case .yes: return NSLocalizedString("Yes", comment: "Yes/No")
            }
        }
    }

    private var geoprivacy = GeoprivacyOptions.open {
        didSet {
            geoPrivacyCell.valueLabel?.text = geoprivacy.localized
        }
    }
    private var captive = ChooseBool.no {
        didSet {
            captiveCell.valueLabel?.text = captive.localized
        }
    }
    private var observedOn = Date() {
        didSet {
            let formater = DateFormatter()
            formater.dateStyle = .medium
            formater.timeStyle = .short
            dateCell.textLabel?.text = formater.string(from: observedOn)
        }
    }
    private var observationLocation: CLLocation? {
        didSet {
            showLocation(observationLocation)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCells()

        observedOn = Date()
        geoprivacy = .open
        captive = .no

        setLocation(observationLocation)
    }
    
    private func setupCells() {
        taxaCell.taxaView.taxaPhotoImageView.image = #imageLiteral(resourceName: "Square Question-40")
        taxaCell.taxaView.taxaNameLabel.text = NSLocalizedString("What did you see?", comment: "Empty taxa")
        taxaCell.taxaView.taxaSciNameLabel.text = NSLocalizedString("View suggestions", comment: "Empty taxa")

        notesTextView.text = ""
        notesTextView.placeholder = NSLocalizedString("Notes...", comment: "Placeholder for notes")
        locationCell.detailTextLabel?.text = nil
    }

    private func setLocation(_ location: CLLocation?) {
        firstly { () -> Promise<[CLLocation]> in
                if let location = location {
                    return Promise.value([location])
                } else {
                    return CLLocationManager.requestLocation()
                }
            }.done { locations in
                self.observationLocation = locations.last!
            }.catch { error in
                self.observationLocation = nil
        }
    }

    private func showLocation(_ location: CLLocation?) {
        guard let location = location else {
            locationCell.textLabel?.text = NSLocalizedString("No location", comment: "Unable to access location data")
            locationCell.detailTextLabel?.text = nil
            return
        }
        let locationString = String(format: "Lat: %.3f  Long: %.3f  Acc: %3.0f m",
                                    location.coordinate.latitude,
                                    location.coordinate.longitude,
                                    location.horizontalAccuracy)
        self.locationCell.detailTextLabel?.text = locationString

        CLGeocoder().reverseGeocode(location: location)
            .done { placemarks in
                let placemark = placemarks.first!
                let name = placemark.name ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let isoCountryCode = placemark.isoCountryCode ?? ""
                let placeGuess = [name, locality, administrativeArea, isoCountryCode].joined(separator: ", ")
                self.locationCell.textLabel?.text = placeGuess
            }.catch { error in
                print(error)
                self.locationCell.textLabel?.text = NSLocalizedString("Unable to find location name", comment: "place guess when we have lat/lng but it's not geocoded")
        }

    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        if cell == taxaCell, mainAsset == nil {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case dateCell:
            let datePickerView = UIDatePicker()
            datePickerView.date = observedOn
            datePickerView.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: observedOn)
            datePickerView.maximumDate = Calendar.current.date(byAdding: .minute, value: 10, to: observedOn)
            datePickerView.minuteInterval = 10
            pickDate(title: "Select Date", datePicker: datePickerView)
                .done {
                    self.observedOn = $0
                }.ignoreErrors()
        case geoPrivacyCell:
            let title = NSLocalizedString("Select Privacy", comment: "title for geoprivacy selector")
            pickValue(title: title, initial: geoprivacy)
                .done {
                    self.geoprivacy = $0
                }.ignoreErrors()
        case captiveCell:
            let title = NSLocalizedString("Captive?", comment: "title for captive selector")
            pickValue(title: title, initial: captive)
                .done {
                    self.captive = $0
                }.ignoreErrors()
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        switch destination {
        case let taxaSearchViewController as TaxaSearchViewController:
            taxaSearchViewController.asset = mainAsset
            taxaSearchViewController.location = observationLocation?.coordinate
            taxaSearchViewController.observedOn = observedOn
            taxaSearchViewController.delegate = self
        case let editLocationViewController as EditLocationViewController:
            editLocationViewController.delegate = self
            editLocationViewController.currentLocation = observationLocation?.coordinate
        default:
            break
        }
    }


    func createRequest() -> NatAPI? {
        var title: String?
        var msg: String?
        if taxon == nil {
            title = NSLocalizedString("Missing Identification", comment: "")
            msg = NSLocalizedString("Please identify", comment: "")
        }
        if observationLocation == nil {
            title = NSLocalizedString("Missing Location", comment: "")
            msg = NSLocalizedString("Without a location, this observation will be very hard for others to identify and will never attain research grade.", comment: "")
        }
        if let title = title, let msg = msg {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(alert, animated: true)
            return nil
        }

        let target = NatAPI.createObservation(taxonId: taxon!.id,
                                              observedOn: observedOn,
                                              captive: captive == .yes,
                                              geoprivacy: geoprivacy,
                                              location: observationLocation,
                                              place: placeGuess,
                                              description: notesTextView.text)
        return target
    }
}

extension AddObservationTableViewController: TaxaSearchViewProtocol {
    func selected(_ taxon: Taxon) {
        taxaCell.setup(taxon: taxon)
        self.taxon = taxon
    }
}

extension AddObservationTableViewController: EditLocationViewControllerProtocol {
    func setLocation(coordinate: CLLocationCoordinate2D, positionalAccuracy: Double) {
        observationLocation = CLLocation(coordinate: coordinate,
                   altitude: 0,
                   horizontalAccuracy: positionalAccuracy,
                   verticalAccuracy: 0,
                   course: 0,
                   speed: 0,
                   timestamp: Date())
    }
}
