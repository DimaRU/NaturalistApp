/////
////  StringExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }

    func uppercasedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    func emptyToNil() -> String? {
        guard self != ""  else { return nil }
        return self
    }
}
