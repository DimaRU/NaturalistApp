//
//  UIViewControllerExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateFromMainStoryboard<T: UIViewController>() -> T {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    static func instantiateFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
}
