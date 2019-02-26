//
//  IconicTaxonName+Color.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 26/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension IconicTaxonName {
    var color: UIColor {
        let colorRGB: Int
        switch self {
        case .plantae        : colorRGB = 0x73ac13
        case .animalia       : colorRGB = 0x1e90ff
        case .mollusca       : colorRGB = 0xff4500
        case .reptilia       : colorRGB = 0x1e90ff
        case .aves           : colorRGB = 0x1e90ff
        case .amphibia       : colorRGB = 0x1e90ff
        case .actinopterygii : colorRGB = 0x1e90ff
        case .mammalia       : colorRGB = 0x1e90ff
        case .insecta        : colorRGB = 0xff4500
        case .arachnida      : colorRGB = 0xff4500
        case .fungi          : colorRGB = 0xff0066
        case .protozoa       : colorRGB = 0x691776
        case .chromista      : colorRGB = 0x993300
        case .unknown        : colorRGB = 0x1e90ff
        }
        return UIColor.init(color: colorRGB)
    }
}
