//
//  Fave.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias FaveId = Int
struct Fave: Decodable {
    let id: FaveId
    let voteFlag: Bool
    let userId: Int
    let createdAt: Date
    let user: User
}
