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
    case searchObservations(page: Int, userId: UserId?, havePhoto: Bool?, poular: Bool?)
    case searchTaxon(page: Int, name: String?)
    case currentUser()
    case users(ids: [UserId])
    case taxon(taxonId: TaxonId)
    
    
    public var baseURL: URL {
        return URL(string: "https://www")!
    }
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return Moya.Method.get
    }
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
    }
    
    public var headers: [String : String]? {
        return nil
    }
}
