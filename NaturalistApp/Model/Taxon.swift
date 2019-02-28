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
        case phylum
        case kingdom
        case subphylum
        case superclass
        case `class`
        case subclass
        case infraclass
        case superorder
        case order
        case suborder
        case infraorder
        case superfamily
        case epifamily
        case family
        case subfamily
        case supertribe
        case tribe
        case subtribe
        case genus
        case genushybrid
        case subgenus
        case section
        case subsection
        case complex
        case species
        case hybrid
        case subspecies
        case varietycase
        case form
        case stateofmatter
        case variety
    }

    let id: TaxonId
    let name: String
    let preferredCommonName: String?
    let defaultPhoto: Photo?
    let wikipediaUrl: String?
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
    let rankLevel: Int
    let atlasId: Int?
    let parentId: Int?
    let iconicTaxonName: IconicTaxonName?
    let completeRank: Rank?
    let ancestors: [Taxon]?
    let endemic: Bool?
    let threatened: Bool?
    let introduced: Bool?
    let native: Bool?
}
