//
//  TaxonDetailViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import MapKit

protocol TaxonDetailProtocol: AnyObject {
    func showWikipediaPage()
    func openInaturalist()
}

class TaxonDetailViewController: StackViewController {
    private let webContentView = TaxonWebContentView.instantiate()
    private let mapHeaderView = TaxonMapheaderView.instantiate()
    private var photoViewController: PhotoViewController!
    private var fullTaxon: Taxon?
    
    var observationId: ObservationId?
    var observationCoordinate: CLLocationCoordinate2D?
    var taxon: Taxon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = taxon.preferredCommonName
        view.backgroundColor = UIColor(red:0.88, green:0.89, blue:0.90, alpha:1.00)
        spacing = 0
        setupUI()
        loadFullTaxon()
    }
    
    private func loadFullTaxon() {
        NatProvider.shared.request(.taxon(id: taxon.id))
            .done { (results: PagedResults<Taxon>) in
                self.fullTaxon = results.results.content.first
                self.webContentView.setup(taxon: self.fullTaxon!, delegate: self)
                if let taxonPhotos = self.fullTaxon?.taxonPhotos {
                    self.photoViewController.photos = taxonPhotos.map{ $0.photo }
                    self.photoViewController.captions = taxonPhotos.map{ $0.photo.attribution }
                    self.photoViewController.refreshData()
                }
            }.ignoreErrors()
    }

    private func setupUI() {
        photoViewController = PhotoViewController.instantiate()
        if let photo = taxon.defaultPhoto {
            photoViewController.photos = [photo]
            photoViewController.captions = [photo.attribution]
        }
        photoViewController.imageContentMode = .scaleAspectFit
        add(photoViewController)
        
        webContentView.setup(taxon: taxon, delegate: self)
        add(webContentView)
        add(mapHeaderView)
        let mapViewController = TaxonMapViewController.instantiate()
        mapViewController.observationId = observationId
        mapViewController.observationCoordinate = observationCoordinate
        mapViewController.taxon = taxon
        add(mapViewController)
    }
}

extension TaxonDetailViewController: TaxonDetailProtocol {
    func openInaturalist() {
        let urlString = "https://www.inaturalist.org/taxa/" + String(taxon.id)
        let url = URL(string: urlString)!
        UIApplication.shared.open(url)
    }
    
    func showWikipediaPage() {
        guard let url = fullTaxon?.wikipediaUrl else { return }
        let vc = WebViewController()
        vc.url = url
        navigationController?.pushViewController(vc, animated: true)
    }
}
