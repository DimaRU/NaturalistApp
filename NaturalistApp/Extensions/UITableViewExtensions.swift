/////
////  UITableViewExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(of type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
