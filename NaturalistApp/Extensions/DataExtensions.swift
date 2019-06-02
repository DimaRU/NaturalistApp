/////
////  DataExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension Data {
    func GPSDictionary() -> [AnyHashable: Any] {
        guard let source = CGImageSourceCreateWithData(self as CFData, nil) else { return [:] }
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [AnyHashable: Any] else { return [:] }
        return metadata[kCGImagePropertyGPSDictionary] as? [AnyHashable: Any] ?? [:]
    }
}
