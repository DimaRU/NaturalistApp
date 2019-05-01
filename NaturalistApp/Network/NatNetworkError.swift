//
//  NatNetworkError.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

enum NatNetworkError: Error {
    case authorizationNeed(message: String)
    case notFound(message: String)
    case responceSyntaxError(message: String)
    case serverError(code: Int)
    case unaviable
    
    func message() -> String {
        switch self {
        case
             .authorizationNeed(let message),
             .notFound(let message),
             .responceSyntaxError(let message):
            return message
        case .serverError(let code):
            return "code \(code)"
        case .unaviable:
            return ""
        }
    }
}

extension NatNetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authorizationNeed:
            return NSLocalizedString("Unsucessful authorisation", comment: "Network error")
        case .notFound:
            return NSLocalizedString("Resource not found", comment: "Network error")
        case .responceSyntaxError:
            return NSLocalizedString("Responce syntax error", comment: "Network error")
        case .serverError:
            return NSLocalizedString("Server error", comment: "Network error")
        case .unaviable:
            return NSLocalizedString("Network unaviable", comment: "Network error")
        }
    }
    
}
