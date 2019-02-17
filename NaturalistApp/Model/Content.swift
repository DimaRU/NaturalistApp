//
//  Content.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

protocol ResultsContent: Codable {}

struct Content<T: ResultsContent> {
    let content: [T]
}

extension Content: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = Content(content: try container.decode([T].self))
    }
}
