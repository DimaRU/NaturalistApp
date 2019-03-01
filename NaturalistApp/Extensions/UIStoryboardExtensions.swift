//
//  UIStoryboardExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 01/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(of type: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
