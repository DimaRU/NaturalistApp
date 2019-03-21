//
//  FullScreenNavigationViewController.swift
//  PhotoViewController
//
//  Created by Dmitriy Borovikov on 20/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class FullScreenNavigationViewController: UINavigationController {
    override var prefersStatusBarHidden: Bool {
        return navigationBar.isHidden
    }
}
