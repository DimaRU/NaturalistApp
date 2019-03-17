//
//  MapBounds.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct MapBounds: Decodable {
    let swlat: Double
    let swlng: Double
    let nelat: Double
    let nelng: Double
}
