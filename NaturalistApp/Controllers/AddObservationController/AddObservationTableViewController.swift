//
//  AddObservationTableViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 15/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class AddObservationTableViewController: UITableViewController {

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var geoPrivacyCell: TitleValueTableViewCell!
    @IBOutlet weak var captiveCell: TitleValueTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCells()
    }
    
    private func setupCells() {
        notesTextView.text = ""
        notesTextView.placeholder = NSLocalizedString("Notes...", comment: "Placeholder for observation notes when making a new observation.")

        dateCell.textLabel?.text = "No date"
        
        locationCell.textLabel?.text = "No location"
        locationCell.detailTextLabel?.text = ""
        
        geoPrivacyCell.titleLabel?.text = "Geoprivacy"
        geoPrivacyCell.valueLabel?.text = "Public"
        
        captiveCell.titleLabel?.text = "Captive/cultivated"
        geoPrivacyCell.valueLabel?.text = "No"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected:", indexPath.row)
    }

}
