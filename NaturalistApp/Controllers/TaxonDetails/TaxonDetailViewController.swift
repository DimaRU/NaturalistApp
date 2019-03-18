//
//  TaxonDetailViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import MapKit

class TaxonDetailViewController: StackViewController {

    var observationId: ObservationId?
    var observationCoordinate: CLLocationCoordinate2D?
    var taxon: Taxon!
    var fullTaxon: Taxon?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = taxon.preferredCommonName
        view.backgroundColor = UIColor(red:0.88, green:0.89, blue:0.90, alpha:1.00)
        spacing = 2
        setupUI()
        loadFullTaxon()
    }
    
    private func loadFullTaxon() {
        NatProvider.shared.request(.taxon(id: taxon.id))
            .done { (results: PagedResults<Taxon>) in
                self.fullTaxon = results.results.content.first
                print(self.fullTaxon?.taxonPhotos?.count)
                print(self.fullTaxon?.wikipediaSummary)
            }.ignoreErrors()
    }

    private func setupUI() {
        if let photos = taxon.taxonPhotos, !photos.isEmpty {
            let photoViewController = PhotoViewController.instantiate()
            photoViewController.photos = photos.map { $0.photo }
            photoViewController.captions = photos.map { $0.photo.attribution }
            photoViewController.imageContentMode = .scaleAspectFit
            add(photoViewController)
        }
        let mapViewController = TaxonMapViewController.instantiate()
        mapViewController.observationId = observationId
        mapViewController.observationCoordinate = observationCoordinate
        mapViewController.taxon = taxon
        add(mapViewController)
    }
}
