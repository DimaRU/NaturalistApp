//
//  StoryboardInstantiable.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 04/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: AnyObject {
    static func instantiateFromMainStoryboard() -> Self
}

extension StoryboardInstantiable {
    static func instantiateFromMainStoryboard() -> Self {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let name = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: name) as! Self
    }
}
