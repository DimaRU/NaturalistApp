/////
////  TaxonScore.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct TaxonScore: ResultsContent {
    let taxon: Taxon
    let visionScore: Double
    let frequencyScore: Double?
    let combinedScore: Double
}
