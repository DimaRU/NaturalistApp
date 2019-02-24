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

    enum IconicTaxonName: String, Codable, DefaultCaseRepresentable {
        case plantae = "Plantae"
        case animalia = "Animalia"
        case mollusca = "Mollusca"
        case reptilia = "Reptilia"
        case aves = "Aves"
        case amphibia = "Amphibia"
        case actinopterygii = "Actinopterygii"
        case mammalia = "Mammalia"
        case insecta = "Insecta"
        case arachnida = "Arachnida"
        case fungi = "Fungi"
        case protozoa = "Protozoa"
        case chromista = "Chromista"
        case unknown = "unknown"
        
        static let defaultCase = IconicTaxonName.unknown
    }
    
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
    let taxonSchemesCount: Int
    let ancestry: String?
    let minSpeciesAncestry: String?
    let wikipediaUrl: String?
    let currentSynonymousTaxonIds: [Int]?
    let iconicTaxonId: Int?
    let createdAt: Date?
    let taxonChangesCount: Int
    let completeSpeciesCount: Int?
    let rank: Rank
    let extinct: Bool
    let universalSearchRank: Int?
    let ancestorIds: [Int]
    let observationsCount: Int
    let isActive: Bool
    let rankLevel: Int
    let atlasId: Int?
    let parentId: Int?
    let name: String
    let defaultPhoto: Photo?
    let iconicTaxonName: IconicTaxonName?
    let preferredCommonName: String?
    let completeRank: Rank?
    let ancestors: [Taxon]?
    let endemic: Bool?
    let threatened: Bool?
    let introduced: Bool?
    let native: Bool?
}
