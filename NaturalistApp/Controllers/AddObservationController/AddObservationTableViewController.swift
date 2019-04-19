//
//  AddObservationTableViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 15/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

class AddObservationTableViewController: UITableViewController {

    @IBOutlet weak var emptyTaxaCell: UITableViewCell!
    @IBOutlet weak var taxaCell: AddObservationTaxaTableViewCell!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var geoPrivacyCell: TitleValueTableViewCell!
    @IBOutlet weak var captiveCell: TitleValueTableViewCell!

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
    private var observationDate = Date() {
        didSet {
            let formater = DateFormatter()
            formater.dateStyle = .medium
            formater.timeStyle = .short
            dateCell.textLabel?.text = formater.string(from: observationDate)
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

        observationDate = Date()
        geoprivacy = .open
        captive = .no

        setupLocation(observationLocation)
    }
    
    private func setupCells() {
        taxaCell.taxaView.taxaPhotoImageView.image = #imageLiteral(resourceName: "Square Question-40")
        taxaCell.taxaView.taxaNameLabel.text = NSLocalizedString("What did you see?", comment: "Empty taxa")
        taxaCell.taxaView.taxaSciNameLabel.text = NSLocalizedString("View suggestions", comment: "Empty taxa")

        notesTextView.text = ""
        notesTextView.placeholder = NSLocalizedString("Notes...", comment: "Placeholder for notes")
        locationCell.detailTextLabel?.text = nil
    }

    private func setupLocation(_ location: CLLocation?) {
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
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case taxaCell:
            print("TaxaSearchViewController")
        case dateCell:
            let datePickerView = UIDatePicker()
            datePickerView.date = observationDate
            datePickerView.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: observationDate)
            datePickerView.maximumDate = Calendar.current.date(byAdding: .minute, value: 10, to: observationDate)
            datePickerView.minuteInterval = 10
            pickDate(title: "Select Date", datePicker: datePickerView)
                .done {
                    self.observationDate = $0
                }.ignoreErrors()
        case locationCell:
            print("EditLocationViewController")
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
}
