//
//  ObservationDetailsViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

protocol FaveChangeProtocol: AnyObject {
    func faveChange()
}

class ObservationDetailsViewController: StackViewController, ObservationDetailProtocol {
    private let profileView = ObservationProfileView.instantiate()

    var observation: Observation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.88, green:0.89, blue:0.90, alpha:1.00)
        spacing = 1
        setupUI()
//        loadFullObservation()
    }

    func setupUI() {
        profileView.setup(observation: observation, delegate: self)
        add(profileView)
        
        if !observation.photos.isEmpty {
            let photoViewController = PhotoViewController.instantiate()
            photoViewController.photos = observation.photos
            photoViewController.imageContentMode = .scaleAspectFill
            add(photoViewController)
        }
        
        let activityViewController = ActivityViewController.instantiate()
        activityViewController.observation = observation
        add(activityViewController)
    }
    
    func loadFullObservation() {
        firstly {
            // start
            NatProvider.shared.request(.observation(id: observation.id))
            }.done { (pagedResult: PagedResults<Observation>) in
                self.observation = pagedResult.results.content.first
//                self.descriptionView.setup(description: self.observation.description)
            }.ignoreErrors()
    }

}
