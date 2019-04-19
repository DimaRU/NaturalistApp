//
//  GeoprivacyOptions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 19/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

enum GeoprivacyOptions: String, CaseIterable, Decodable {
    case open, obscured, `private`
}

extension GeoprivacyOptions: Localizable {
    var localized: String {
        switch self {
        case .open:
            return NSLocalizedString("Open", comment: "open geoprivacy")
        case .obscured:
            return NSLocalizedString("Obscured", comment: "obscured geoprivacy")
        case .private:
            return  NSLocalizedString("Private", comment: "private geoprivacy")
        }
    }
}
