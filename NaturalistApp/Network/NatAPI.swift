//
//  NatAPI.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Moya
import Result

typealias MoyaResult = Result<Moya.Response, Moya.MoyaError>

enum NatAPI: TargetType {
    case authorize(login: String, password: String)
    case apiToken(bearer: String)
    case searchObservations(perPage: Int, page: Int, userId: UserId?, havePhoto: Bool?, poular: Bool?)
    case getObservationsBox(perPage: Int, page: Int, nelat: Double, nelng: Double, swlat: Double, swlng: Double)
    case searchTaxon(perPage: Int, page: Int, name: String?)
    case currentUser
    case users(ids: [UserId])
    case taxon(id: TaxonId)
    case observation(id: ObservationId)
    case fave(id: ObservationId)
    case unfave(id: ObservationId)

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
             .getObservationsBox:
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
             .observation:
            return .get
        case .fave:
            return .post
        case .unfave:
            return .delete
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
            parameters["photos"] = havePhoto?.description
            parameters["popular"] = poular?.description
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getObservationsBox(let perPage, let page, let nelat, let nelng, let swlat, let swlng):
            parameters["per_page"] = perPage
            parameters["page"] = page
            parameters["mappable"] = true.description
            parameters["verifiable"] = true.description
            parameters["nelat"] = nelat
            parameters["nelng"] = nelng
            parameters["swlat"] = swlat
            parameters["swlng"] = swlng
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .searchTaxon(let perPage, let page, let name):
            parameters["per_page"] = perPage
            parameters["page"] = page
            parameters["q"] = name
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .currentUser,
             .users,
             .taxon,
             .observation,
             .fave,
             .unfave:
            return .requestPlain
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
             .unfave:
            assigned["Authorization"] = KeychainService.shared[.apiToken]
        default:
            break
        }
        return assigned
    }
    
    public var sampleData: Data {
        return Data()
    }
}
