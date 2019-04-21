//
//  CommonAncestor.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 21/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct CommonAncestor: Decodable {
    let taxon: Taxon
    let score: Double
}
