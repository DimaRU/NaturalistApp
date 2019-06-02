/////
////  AccessToken.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct AccessToken: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
