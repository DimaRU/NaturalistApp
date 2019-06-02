/////
////  UIStoryboardExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(of type: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
