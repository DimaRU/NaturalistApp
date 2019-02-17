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
    case searchObservations(page: Int, userId: UserId?, havePhoto: Bool?, poular: Bool?)
    case searchTaxon(page: Int, name: String?)
    case currentUser
    case users(ids: [UserId])
    case taxon(taxonId: TaxonId)
    
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
        case .searchObservations:
            return "\(apiVersion)/observations"
        case .searchTaxon:
            return "\(apiVersion)/taxa"
        case .currentUser:
            return "\(apiVersion)/users/me"
        case .users(let ids):
            return "\(apiVersion)/users/\(ids)"
        case .taxon(let taxonId):
            return "\(apiVersion)/taxa/\(taxonId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .authorize:
            return .post
        case .apiToken:
            return .get
        case .searchObservations,
             .searchTaxon,
             .currentUser,
             .users,
             .taxon:
            return .get
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
        case .searchObservations(let page, let userId, let havePhoto, let poular):
            parameters["per_page"] = 20
            parameters["page"] = page
            parameters["user_id"] = userId
            parameters["photos"] = havePhoto
            parameters["popular"] = poular
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .searchTaxon(let page, let name):
            parameters["per_page"] = 20
            parameters["page"] = page
            parameters["q"] = name
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .currentUser,
             .users,
             .taxon:
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
        case .currentUser:
            assigned["Authorization"] = KeychainService.shared[.apiToken]
        case .searchObservations,
             .searchTaxon,
             .users,
             .taxon:
            break
        }
        return assigned
    }
    
    public var sampleData: Data {
        return Data()
    }
}
