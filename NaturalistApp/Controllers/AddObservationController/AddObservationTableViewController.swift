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

    override func viewDidLoad() {
        super.viewDidLoad()

        notesTextView.text = ""
        notesTextView.placeholder = NSLocalizedString("Notes...", comment: "Placeholder for observation notes when making a new observation.")
    }


}
