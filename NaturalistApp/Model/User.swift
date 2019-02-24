//
//  User.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias UserId = Int

struct User: ResultsContent {
    let id: UserId
    let login: String
    let spam: Bool
    let suspended: Bool
    let loginAutocomplete: String
    let loginExact: String
    let name: String?
    let nameAutocomplete: String?
    let icon: URL?
    let observationsCount: Int
    let identificationsCount: Int
    let journalPostsCount: Int
    let activityCount: Int
    let universalSearchRank: Int?
    let roles: [String]
    let iconUrl: URL?
    // Private part
    let email: String?
    let locale: String?
    let placeId: Int?
    let prefersScientificNameFirst: Bool?
}
