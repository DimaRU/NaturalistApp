//
//  ObservationDetailsViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

protocol ObservationDetailProtocol: AnyObject {
    func faveChange()
    func showFavedUsers()
    func showUserProfile()
    func showTaxaDetails()
}

class ObservationDetailsViewController: StackViewController {
    private let profilleView = ObservationProfilleView.instantiate()
    private let taxaView = ObservationTaxaView.instantiate()
    private let faveView = ObservationFaveView.instantiate()
    
    var observation: Observation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.88, green:0.89, blue:0.90, alpha:1.00)
        spacing = 2
        setupUI()
        //        reLoadObservation()
    }

    func setupUI() {
        profilleView.setup(observation: observation, delegate: self)
        taxaView.setup(observation: observation, delegate: self)
        faveView.setup(observation: observation, delegate: self)
        let photoViewController = PhotoViewController.instantiateFromStoryboard()
        photoViewController.photos = observation.photos
        add(profilleView)
        add(photoViewController)
        add(taxaView)
        add(faveView)
    }
    
    
    func reloadData(_ object: NSObject) {
        
    }
    
    func reLoadObservation() {
        firstly {
            // start
            NatProvider.shared.request(.observation(id: observation.id))
            }.done { (pagedResult: PagedResults<Observation>) in
                self.observation = pagedResult.results.content.first
//                self.reloadData()
            }.ignoreErrors()
    }
}


extension ObservationDetailsViewController: ObservationDetailProtocol {
    func showTaxaDetails() {
        #warning ("Todo: show taxon details")
    }
    
    func showUserProfile() {
        let vc = ProfileCollectionViewController.instantiateFromMainStoryboard()
        vc.user = observation.user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func faveChange() {
        let endpoint: NatAPI = observation.favedByMe ? .unfave(id: observation.id) : .fave(id: observation.id)
        NatProvider.shared.request(endpoint)
            .done { (observation: Observation) in
                self.observation = observation
                self.faveView.setup(observation: observation, delegate: self)
            }.ignoreErrors()
    }
    
    func showFavedUsers() {
        #warning ("Todo: Show faved users tap")
        print("Show faved users tap")
    }
}
