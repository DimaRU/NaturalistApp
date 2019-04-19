//
//  AddObservationViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 13/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Photos
import PromiseKit

class AddObservationViewController: UIViewController, MainStoryboardInstantiable {
    private var assets: [PHAsset] = []
    private var mainAsset: PHAsset?
    private var pickPhotoController: PickPhotoController!
    private var observationTableController: AddObservationTableViewController!
    

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickPhotoController = (children.first as! PickPhotoController)
        observationTableController = (children.last as! AddObservationTableViewController)
        pickPhotoController.delegate = self
    }

    @IBAction func shareButtonTap(_ sender: Any) {
        print("Share")
    }
}

extension AddObservationViewController: PickPhotoControllerProtocol {
    func selected(assets: [PHAsset]) {
        self.assets = assets
        if mainAsset != assets.first {
            mainAsset = assets.first
            observationTableController.mainAsset = mainAsset
        }
    }
}
