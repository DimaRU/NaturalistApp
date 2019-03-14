//
//  Identification.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 13/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias IdentificationId = Int

struct Identification: Decodable {
    let id: IdentificationId
    let uuid: String
    let user: User
    let createdAt: Date
    let createdAtDetails: Details
    let category: String
    let current: Bool
    let ownObservation: Bool
    let vision: Bool
    let spam: Bool
    let taxonId: TaxonId
    let taxon: Taxon
    let disagreement: Bool?
    let previousObservationTaxonID: TaxonId?
    let previousObservationTaxon: Taxon?
}
