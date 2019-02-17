//
//  PagedResults.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct PagedResults<T: ResultsContent>: Decodable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let results: Content<T>
}
