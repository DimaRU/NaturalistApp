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
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTap(_:)))
        profileView.addGestureRecognizer(recognizer)
        profileView.setup(observation: observation)

        add(profileView)
        
        if !observation.photos.isEmpty {
            let photoViewController = PhotoViewController.instantiate()
            photoViewController.photos = observation.photos.map{
                PhotoViewController.Photo(previewUrl: $0.mediumUrl,
                                          fullSizeUrl: $0.originalUrl,
                                          caption: nil)
            }
            photoViewController.imageContentMode = .scaleAspectFill
            add(photoViewController)
        }
        
        let activityViewController = ActivityViewController.instantiate()
        activityViewController.observation = observation
        add(activityViewController)
    }

    @objc func profileViewTap(_ sender: Any) {
        showUserProfile(user: observation.user)
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
