/////
////  PagedResults.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct PagedResults<T: ResultsContent>: Decodable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let totalBounds: MapBounds?
    let commonAncestor: CommonAncestor?
    let results: Content<T>
}
