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
        
        view.backgroundColor = UIColor(red:0.88, green:0.89, blue:0.90, alpha:1.00)
        spacing = 2
        setupUI()
    }
    
    private func loadFullTaxon() {
        NatProvider.shared.request(.taxon(id: taxon.id))
            .done { (results: PagedResults<Taxon>) in
                self.fullTaxon = results.results.content.first
            }.ignoreErrors()
    }

    private func loadJson() -> Observation {
        let file = Bundle.main.path(forResource: "observation", ofType: "json")!
        let fileContents = try! Data(contentsOf: URL(fileURLWithPath: file))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        let paged = try! decoder.decode(PagedResults<Observation>.self, from: fileContents)
        return paged.results.content[0]
    }

    private func setupUI() {
        let mapViewController = TaxonMapViewController.instantiate()
        mapViewController.observationId = observationId
        mapViewController.observationCoordinate = observationCoordinate
        mapViewController.taxon = taxon
        add(mapViewController)
    }
}
