/////
////  Comment.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias CommentId = Int
struct Comment: Decodable {
    let id: CommentId
    let body: String
    let uuid: String
    let createdAt: Date
    let user: User
}
