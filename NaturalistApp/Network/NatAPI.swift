//
//  NatAPI.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Moya
import Result
import CoreLocation

typealias MoyaResult = Result<Moya.Response, Moya.MoyaError>

enum NatAPI: TargetType {
    case authorize(login: String, password: String)
    case apiToken(bearer: String)
    case searchObservations(perPage: Int, page: Int, userId: UserId?, havePhoto: Bool?, poular: Bool?)
    case searchTaxonBounds(id: TaxonId)
    case getObservationsBox(perPage: Int, page: Int, nelat: Double, nelng: Double, swlat: Double, swlng: Double)
    case searchTaxon(perPage: Int, page: Int, name: String?)
    case currentUser
    case users(ids: [UserId])
    case taxon(id: TaxonId)
    case observation(id: ObservationId)
    case fave(id: ObservationId)
    case unfave(id: ObservationId)
    case observers(perPage: Int, page: Int, taxonIds: [TaxonId], observationId: ObservationId?, userId: UserId?)
    case identifiers(perPage: Int, page: Int, taxonIds: [TaxonId], observationId: ObservationId?, userId: UserId?)
    case scoreImage(image: Data, type: String, name: String, date: Date, location: CLLocationCoordinate2D?)
    case createObservation(taxonId: TaxonId, observedOn:Date, captive: Bool, geoprivacy: GeoprivacyOptions, location: CLLocation?, place: String?, description: String?)

    var apiVersion: String {
        return "/v1"
    }

    public var baseURL: URL {
        switch self {
        case .authorize,
             .apiToken:
            return URL(string: "https://www.inaturalist.org")!
        default:
            return URL(string: "https://api.inaturalist.org")!
        }
    }
    
    public var path: String {
        switch self {
        case .authorize:
            return "/oauth/token"
        case .apiToken:
            return "/users/api_token"
        case .searchObservations,
             .getObservationsBox,
             .searchTaxonBounds:
            return "\(apiVersion)/observations"
        case .searchTaxon:
            return "\(apiVersion)/taxa"
        case .currentUser:
            return "\(apiVersion)/users/me"
        case .users(let ids):
            return "\(apiVersion)/users/\(ids)"
        case .taxon(let id):
            return "\(apiVersion)/taxa/\(id)"
        case .observation(let id):
            return "\(apiVersion)/observations/\(id)"
        case .fave(let id):
            return "\(apiVersion)/observations/\(id)/fave"
        case .unfave(let id):
            return "\(apiVersion)/observations/\(id)/unfave"
        case .observers:
            return "\(apiVersion)/observations/observers"
        case .identifiers:
            return "\(apiVersion)/observations/identifiers"
        case .scoreImage:
            return "\(apiVersion)/computervision/score_image"
        case .createObservation:
            return "\(apiVersion)/observations"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .authorize:
            return .post
        case .apiToken:
            return .get
        case .searchObservations,
             .getObservationsBox,
             .searchTaxon,
             .currentUser,
             .users,
             .taxon,
             .observation,
             .searchTaxonBounds,
             .observers,
             .identifiers:
            return .get
        case .fave:
            return .post
        case .unfave:
            return .delete
        case .scoreImage:
            return .post
        case .createObservation:
            return .post
        }
    }
    
    public var task: Task {
        var parameters: [String : Any] = [:]

        switch self {
        case .authorize(let login, let password):
            parameters["client_id"] = APIKeys.shared.clientId
            parameters["client_secret"] = APIKeys.shared.clientSecret
            parameters["grant_type"] = "password"
            parameters["username"] = login
            parameters["password"] = password
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .apiToken:
            return .requestPlain
        case .searchObservations(let perPage, let page, let userId, let havePhoto, let poular):
            parameters["per_page"] = perPage
            parameters["page"] = page
            parameters["user_id"] = userId
            parameters["photos"] = havePhoto
            parameters["popular"] = poular
            return .requestParameters(parameters: parameters, encoding: NatAPI.urlEncoding)
        case .searchTaxonBounds(let id):
            parameters["per_page"] = 1
            parameters["taxon_id"] = id
            parameters["return_bounds"] = true
            return .requestParameters(parameters: parameters, encoding: NatAPI.urlEncoding)
        case .getObservationsBox(let perPage, let page, let nelat, let nelng, let swlat, let swlng):
            parameters["per_page"] = perPage
            parameters["page"] = page
            parameters["mappable"] = true
            parameters["verifiable"] = true
            parameters["nelat"] = nelat
            parameters["nelng"] = nelng
            parameters["swlat"] = swlat
            parameters["swlng"] = swlng
            return .requestParameters(parameters: parameters, encoding: NatAPI.urlEncoding)
        case .searchTaxon(let perPage, let page, let name):
            parameters["per_page"] = perPage
            parameters["page"] = page
            parameters["q"] = name
            return .requestParameters(parameters: parameters, encoding: NatAPI.urlEncoding)
        case .currentUser,
             .users,
             .taxon,
             .observation,
             .fave,
             .unfave:
            return .requestPlain
        case .observers(let perPage, let page, let taxonIds, let observationId, let userId),
             .identifiers(let perPage, let page, let taxonIds, let observationId, let userId):
            parameters["per_page"] = perPage
            parameters["page"] = page
            parameters["taxon_id"] = taxonIds.map{ String($0) }.joined(separator: ",").emptyToNil()
            parameters["id"] = observationId
            parameters["user_id"] = userId
            return .requestParameters(parameters: parameters, encoding: NatAPI.urlEncoding)
        case .scoreImage(let image, let type, let name, let date, let location):
            let mimeType = type.replacingOccurrences(of: "public.", with: "image/")
            let imageFormData = MultipartFormData(provider: .data(image), name: "image", fileName: name, mimeType: mimeType)
            let dateString = String(date.timeIntervalSince1970)
            let dateFormData = MultipartFormData(provider: .data(dateString.data(using: .utf8)!), name: "observed_on")
            var multpartData = [imageFormData, dateFormData]
            if let location = location {
                let latData = String(location.latitude).data(using: .utf8)!
                let latFormData = MultipartFormData(provider: .data(latData), name: "lat")
                multpartData.append(latFormData)
                let lngData = String(location.longitude).data(using: .utf8)!
                let lngFormData = MultipartFormData(provider: .data(lngData), name: "lng")
                multpartData.append(lngFormData)
            }
            return .uploadCompositeMultipart(multpartData, urlParameters: [:])
        case .createObservation(let taxonId, let observedOn, let captive, let geoprivacy, let location, let place, let description):
            var observation: [String : Any] = [:]
            observation["uuid"] = UUID().uuidString
            observation["taxon_id"] = taxonId
            observation["id_please"] = false
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.locale = .init(identifier: "en_US")
            formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z (zzz)"
            observation["observed_on_string"] = formatter.string(from: observedOn)
            observation["owners_identification_from_vision"] = true
            observation["captive_flag"] = captive
            observation["latitude"] = location?.coordinate.latitude
            observation["longitude"] = location?.coordinate.longitude
            observation["positional_accuracy"] = location?.horizontalAccuracy
            observation["geoprivacy"] = geoprivacy.rawValue
            observation["place_guess"] = place
            observation["description"] = description
            parameters["observation"] = observation
            parameters["ignore_photos"] = true
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: ["inat_site_id": 1])
//            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        var assigned: [String: String] = [
            "Accept"               : "application/json",
            "Content-Type"         : "application/json",
            "User-Agent"           : "NaturalistAPP"
        ]
        
        switch self {
        case .authorize:
            break
        case .apiToken(let bearer):
            assigned["Authorization"] = "Bearer \(bearer)"
        case .currentUser,
             .fave,
             .unfave,
             .scoreImage,
             .createObservation:
            assigned["Authorization"] = KeychainService.shared[.apiToken]
        case .searchObservations,
             .searchTaxonBounds,
             .getObservationsBox,
             .searchTaxon,
             .users,
             .taxon,
             .observation,
             .observers,
             .identifiers:
            break
        }
        return assigned
    }
    
    public var sampleData: Data {
        return Data()
    }

    static let urlEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .literal)
}
