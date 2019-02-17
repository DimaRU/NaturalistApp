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
    
    func message() -> String {
        switch self {
        case
             .authorizationNeed(let message),
             .notFound(let message),
             .responceSyntaxError(let message):
            return message
        case .serverError(let code):
            return "code \(code)"
        }
    }
}

extension NatNetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authorizationNeed:
            return NSLocalizedString("Unsucessful authorisation", comment: "Netwok error")
        case .notFound:
            return NSLocalizedString("Resource not found", comment: "Netwok error")
        case .responceSyntaxError:
            return NSLocalizedString("Responce syntax error", comment: "Netwok error")
        case .serverError:
            return NSLocalizedString("Server error", comment: "Netwok error")
        }
    }
    
}
