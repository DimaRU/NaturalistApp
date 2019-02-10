//
//  Taxon.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias TaxonId = Int
struct Taxon: Codable {

    enum IconicTaxonName: String, Codable {
        case animalia = "Animalia"
        case aves = "Aves"
        case insecta = "Insecta"
        case plantae = "Plantae"
    }
    
    enum Rank: String, Codable {
        case family
        case genus
        case kingdom
        case order
        case phylum
        case rankClass
        case species
        case subclass
        case subfamily
        case suborder
        case subphylum
        case subspecies
        case superfamily
        case tribe
    }

    let id: TaxonId
    let taxonSchemesCount: Int
    let ancestry: String
    let minSpeciesAncestry: String?
    let wikipediaUrl: String?
    let currentSynonymousTaxonIds: [Int]?
    let iconicTaxonId: Int
    let createdAt: Date?
    let taxonChangesCount: Int
    let completeSpeciesCount: Int?
    let rank: Rank
    let extinct: Bool
    let universalSearchRank: Int?
    let ancestorIds: [Int]
    let observationsCount: Int
    let isActive: Bool
    let flagCounts: FlagCounts
    let rankLevel: Int
    let atlasId: Int?
    let parentId: Int
    let name: String
    let defaultPhoto: Photo
    let iconicTaxonName: IconicTaxonName
    let preferredCommonName: String?
    let completeRank: Rank?
    let ancestors: [Taxon]?
    let endemic: Bool?
    let threatened: Bool?
    let introduced: Bool?
    let native: Bool?
}

struct FlagCounts: Codable {
    let unresolved: Int
    let resolved: Int
}

