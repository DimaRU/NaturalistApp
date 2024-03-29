/////
////  PhotoPost.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct PhotoPost: Decodable {
    let id: Int
    let observationId: ObservationId
    let photoId: PhotoId
    let position: Int
    let createdAt: String
    let updatedAt: String
    let oldUuid: String?
    let uuid: String
    let createdAtUtc: String
    let updatedAtUtc: String
}
