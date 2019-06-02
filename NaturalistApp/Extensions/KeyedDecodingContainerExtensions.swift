/////
////  KeyedDecodingContainerExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

public extension KeyedDecodingContainer  {
    func decode(_ type: URL.Type, forKey key: Key) throws -> URL {
        let stringValue = try self.decode(String.self, forKey: key)
        return try decodeURL(from: stringValue)
    }
    
    func decodeIfPresent(_ type: URL.Type, forKey key: Key) throws -> URL? {
        guard let stringValue = try self.decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        return try decodeURL(from: stringValue)
    }
    
    fileprivate func decodeURL(from stringValue: String) throws -> URL {
        guard let urlStringSafe = stringValue.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid URL string - 1.")
            throw DecodingError.dataCorrupted(context)
        }
        guard let url = URL(string: urlStringSafe) else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid URL string - 2.")
            throw DecodingError.dataCorrupted(context)
        }
        return url
    }
}
