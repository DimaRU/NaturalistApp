/////
////  Observer.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct Observer: ResultsContent {
    let userId: UserId
    let observationCount: Int
    let speciesCount: Int
    let user: User
}
