//
//  ObservationDetailProtocol.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 12/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

protocol ObservationDetailProtocol: AnyObject {
    var observation: Observation! { get set }
    func showFavedUsers()
    func showUserProfile(user: User)
    func showTaxaDetails(taxon: Taxon)
}

extension ObservationDetailProtocol where Self: UIViewController {
    func showTaxaDetails(taxon: Taxon) {
        let vc = TaxonDetailViewController()
        vc.observationId = observation.id
        vc.observationCoordinate = observation.coordinate
        vc.taxon = taxon
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showUserProfile(user: User) {
        let vc = ProfileCollectionViewController.instantiate()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showFavedUsers() {
        #warning ("Todo: Show faved users tap")
        print("Show faved users tap")
    }
}

