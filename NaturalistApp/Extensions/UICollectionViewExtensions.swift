//
//  UICollectionViewExtensions.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 06/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

extension UICollectionView {
    func visibleIndexPaths(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsIntersection = Set(self.indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
