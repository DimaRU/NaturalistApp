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
    static func instantiateFromStoryboard() -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
    static func instantiateFromMainStoryboard() -> Self {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let name = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: name) as! Self
    }
    
    static func instantiateFromStoryboard() -> Self {
        let name = String(describing: self)
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        return storyboard.instantiateInitialViewController() as! Self
    }
}
