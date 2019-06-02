/////
////  Identification.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias IdentificationId = Int

struct Identification: Decodable {
    let id: IdentificationId
    let uuid: String
    let user: User
    let createdAt: Date
    let createdAtDetails: Details
    let current: Bool
    let ownObservation: Bool
    let taxonId: TaxonId
    let taxon: Taxon
    let category: String?
    let vision: Bool?
    let spam: Bool?
    let disagreement: Bool?
    let previousObservationTaxonID: TaxonId?
    let previousObservationTaxon: Taxon?
}
