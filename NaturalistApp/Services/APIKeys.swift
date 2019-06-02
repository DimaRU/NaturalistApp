/////
////  APIKeys.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Keys


// Mark: - API Keys
struct APIKeys {
    let clientId: String
    let clientSecret: String

    // MARK: Shared Keys
    static let `default`: APIKeys = {
        return APIKeys(
            clientId: NaturalistAppKeys().clientId,
            clientSecret: NaturalistAppKeys().clientSecret
            )
    }()
    
    static var shared = APIKeys.default
}
