/////
////  IconicTaxonName.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

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
