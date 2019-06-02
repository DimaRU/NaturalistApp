/////
////  KeychainService.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import KeychainAccess

class KeychainService {
    public enum KeychainKeys: String {
        case apiToken
        case bearer
    }

    let keychain: Keychain
    static let shared = KeychainService()
    
    init() {
        // Init keychain access
        let bundleId = Bundle.main.bundleIdentifier!
        keychain = Keychain(service: bundleId)
    }
    
    subscript(key: KeychainKeys) -> String? {
        get {
            return keychain[key.rawValue]
        }
        
        set {
            keychain[key.rawValue] = newValue
        }
    }
    
}
