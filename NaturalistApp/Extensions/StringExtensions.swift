//
//  StringExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 06/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
}
