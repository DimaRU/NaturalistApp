//
//  IndicateStateProtocol.swift
//  CourseFinalTask
//
//  Created by Dmitriy Borovikov on 31/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol IndicateStateProtocol {
    var activityIndicator: UIActivityIndicatorView { get }
    func showActivityIndicator()
    func removeActivityIndicator()
}
