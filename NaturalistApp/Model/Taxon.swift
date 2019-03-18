//
//  Taxon.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias TaxonId = Int
struct Taxon: ResultsContent {

    enum Rank: String, Codable {
        case stateofmatter
        case kingdom
        case subkingdom
        case phylum
        case subphylum
        case superclass
        case `class`
        case subclass
        case infraclass
        case superorder
        case order
        case suborder
        case infraorder
        case subterclass
        case parvorder
        case zoosection
        case zoosubsection
        case superfamily
        case epifamily
        case family
        case subfamily
        case supertribe
        case tribe
        case subtribe
        case genus
        case subgenus
        case section
        case subsection
        case complex
        case species
        case hybrid
        case subspecies
        case variety
        case form
        case infrahybrid
        case leaves
    }

    let id: TaxonId
    let name: String
    let preferredCommonName: String?
    let defaultPhoto: Photo?
    let taxonPhotos: [TaxonPhoto]?
    let wikipediaUrl: URL?
    let rank: Rank
    let taxonSchemesCount: Int
    let ancestry: String?
    let minSpeciesAncestry: String?
    let currentSynonymousTaxonIds: [Int]?
    let iconicTaxonId: Int?
    let createdAt: Date?
    let taxonChangesCount: Int
    let completeSpeciesCount: Int?
    let extinct: Bool
    let universalSearchRank: Int?
    let ancestorIds: [Int]
    let observationsCount: Int
    let isActive: Bool
    let atlasId: Int?
    let parentId: Int?
    let iconicTaxonName: IconicTaxonName?
    let completeRank: Rank?
    let ancestors: [Taxon]?
    let children: [Taxon]
    let endemic: Bool?
    let threatened: Bool?
    let introduced: Bool?
    let native: Bool?
    let listedTaxaCount: Int?
    let listedTaxa: [Taxon]?
    let rankLevel: Int?
    let wikipediaSummary: String?
}
