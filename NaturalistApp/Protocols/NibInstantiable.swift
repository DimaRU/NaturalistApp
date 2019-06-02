/////
////  NibInstantiable.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

protocol NibInstantiable: AnyObject {
    static func instantiate() -> Self
}

extension NibInstantiable where Self: UIView {
    static func instantiate() -> Self {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first! as! Self
    }
}
