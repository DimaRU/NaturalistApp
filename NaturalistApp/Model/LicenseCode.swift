//
//  LicenseCode.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

enum LicenseCode: String, Codable {
    case ccBy = "cc-by"
    case ccByNc = "cc-by-nc"
    case ccByNcNd = "cc-by-nc-nd"
    case ccByNcSa = "cc-by-nc-sa"
    case ccBySa = "cc-by-sa"
    case pd = "pd"
}
