/////
////  TaxonPhoto.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct TaxonPhoto: Decodable {
    let taxonId: TaxonId
    let photo: Photo
}
