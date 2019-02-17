//
//  AccessToken.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct AccessToken: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
