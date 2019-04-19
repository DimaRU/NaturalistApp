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

class AddObservationViewController: UIViewController {
    private var assets: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickPhotoController = children.first as! PickPhotoController
        pickPhotoController.delegate = self
    }

    @IBAction func shareButtonTap(_ sender: Any) {
        print("Share")
    }
}

extension AddObservationViewController: PickPhotoControllerProtocol {
    func selected(assets: [PHAsset]) {
        self.assets = assets
        print(assets.count)
        if let location = assets.first?.location {
            print(location)
        }
    }
}
