//
//  TaxonPhoto.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 01/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct TaxonPhoto: Decodable {
    let taxonId: TaxonId
    let photo: Photo
}
