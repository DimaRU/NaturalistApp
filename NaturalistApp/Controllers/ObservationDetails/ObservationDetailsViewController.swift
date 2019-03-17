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
    private let profileView = ObservationProfilleView.instantiate()
    private let taxaView = ObservationTaxaView.instantiate()
    private let faveView = ObservationFaveView.instantiate()
    private let descriptionView  = ObservationDescription.instantiate()
    
    var observation: Observation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.88, green:0.89, blue:0.90, alpha:1.00)
        spacing = 2
        setupUI()
        loadFullObservation()
    }

    func setupUI() {
        profileView.setup(observation: observation, delegate: self)
        add(profileView)
        
        if !observation.photos.isEmpty {
            let photoViewController = PhotoViewController.instantiate()
            photoViewController.photos = observation.photos
            add(photoViewController)
        }
        
        if observation.taxon != nil {
            taxaView.setup(taxon: observation.taxon, delegate: self)
            add(taxaView)
        }
        descriptionView.setup(description: observation.description)
        add(descriptionView)
        
        faveView.setup(observation: observation, delegate: self)
        add(faveView)
        
        if !(observation.identifications.isEmpty && observation.comments.isEmpty) {
            let activityViewController = ActivityViewController.instantiate()
            activityViewController.observation = observation
            add(activityViewController)
        }
    }
    
    func loadFullObservation() {
        firstly {
            // start
            NatProvider.shared.request(.observation(id: observation.id))
            }.done { (pagedResult: PagedResults<Observation>) in
                self.observation = pagedResult.results.content.first
                self.descriptionView.setup(description: self.observation.description)
                if let description = self.observation.description {
                    print("Description:", description)
                }
            }.ignoreErrors()
    }
}


extension ObservationDetailsViewController: FaveChangeProtocol {
    
    func faveChange() {
        let endpoint: NatAPI = observation.favedByMe ? .unfave(id: observation.id) : .fave(id: observation.id)
        NatProvider.shared.request(endpoint)
            .done { (observation: Observation) in
                self.observation = observation
                self.faveView.setup(observation: observation, delegate: self)
            }.ignoreErrors()
    }
    
}
