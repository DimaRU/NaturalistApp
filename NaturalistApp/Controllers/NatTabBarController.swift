//
//  NatTabBarController.swift
//  CourseFinalTask
//
//  Created by Dmitriy Borovikov on 25/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class NatTabBarController: UITabBarController, MainStoryboardInstantiable {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        for controller in viewControllers ?? [] {
            if let navcontroller = controller as? UINavigationController {
                if let controller = navcontroller.viewControllers.first as? ProfileCollectionViewController {
                    controller.user = Globals.currentUser
                }
            }
        }
    }
}

extension NatTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navController = viewController as? UINavigationController,
            navController.viewControllers.first is AddObservationViewController {
            let addObservationController = AddObservationViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: addObservationController)
            tabBarController.present(navigationController, animated: true)
            return false
        }
        return true
    }
}
