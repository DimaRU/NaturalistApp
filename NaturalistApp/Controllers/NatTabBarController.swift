//
//  NatTabBarController.swift
//  CourseFinalTask
//
//  Created by Dmitriy Borovikov on 25/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class NatTabBarController: UITabBarController, StoryboardInstantiable {
    override func viewDidLoad() {
        super.viewDidLoad()

        for controller in viewControllers ?? [] {
            if let navcontroller = controller as? UINavigationController {
                if let controller = navcontroller.viewControllers.first as? ProfileCollectionViewController {
                    controller.user = Globals.currentUser
                }
            }
        }
    }
}
