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
    func showUserProfile()
    func showTaxaDetails()
}

extension ObservationDetailProtocol where Self: UIViewController {
    func showTaxaDetails() {
        #warning ("Todo: show taxon details")
    }
    
    func showUserProfile() {
        let vc = ProfileCollectionViewController.instantiateFromMainStoryboard()
        vc.user = observation.user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showFavedUsers() {
        #warning ("Todo: Show faved users tap")
        print("Show faved users tap")
    }
}

