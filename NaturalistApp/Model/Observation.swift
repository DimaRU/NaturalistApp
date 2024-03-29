/////
////  Observation.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

typealias ObservationId = Int

struct Observation: ResultsContent {
    let id: ObservationId
    let user: User
    let location: SLocation?
    let positionalAccuracy: Int?
    let placeGuess: String?
    let geoprivacy: GeoprivacyOptions?
    let timeZoneOffset: String
    let observedOn: String?
    let observedOnString: String?
    let observedOnDetails: Details?
    let timeObservedAt: Date?
    let observedTimeZone: String
    let createdAt: Date
    let createdTimeZone: String
    let createdAtDetails: Details
    let updatedAt: Date
    let identifications: [Identification]
    let identificationsSomeAgree: Bool
    let projectIdsWithoutCuratorId: [Int]
    let observationPhotos: [ObservationPhoto]
    let photos: [Photo]
    let communityTaxon: Taxon?
    let favesCount: Int
    let faves: [Fave]
    let mappable: Bool
    let outOfRange: Bool?
    let qualityGrade: QualityGrade
    let taxonGeoprivacy: GeoprivacyOptions?
    let uuid: String
    let cachedVotesTotal: Int
    let identificationsMostAgree: Bool
    let speciesGuess: String?
    let identificationsMostDisagree: Bool
    let commentsCount: Int
    let siteId: Int?
    let idPlease: Bool
    let licenseCode: String?
    let publicPositionalAccuracy: Int?
    let reviewedBy: [Int]
    let oauthApplicationId: Int?
    let description: String?
    let placeIds: [Int]
    let captive: Bool
    let taxon: Taxon?
    let numIdentificationAgreements: Int
    let comments: [Comment]
    let uri: URL?
    let communityTaxonId: Int?
    let geojson: Geojson?
    let ownersIdentificationFromVision: Bool?
    let identificationsCount: Int
    let obscured: Bool
    let numIdentificationDisagreements: Int
    let spam: Bool

    struct ObservationPhoto: Codable {
        let id: Int
        let position: Int
        let uuid: String
        let photo: Photo
    }

    enum QualityGrade: String, Codable {
        case casual = "casual"
        case needsId = "needs_id"
        case research = "research"
    }
}

struct Details: Codable {
    let date: String
    let week: Int
    let month: Int
    let hour: Int
    let year: Int
    let day: Int
}

extension Observation {
    var favedByMe: Bool {
        guard let currentUserId = Globals.currentUser?.id else {
            return false
        }
        return self.faves.first(where: { $0.userId == currentUserId }) != nil
    }
}
