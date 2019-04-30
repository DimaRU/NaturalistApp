//
//  IndicateStateProtocol.swift
//  CourseFinalTask
//
//  Created by Dmitriy Borovikov on 31/01/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol IndicateStateProtocol: AnyObject {
    var activityIndicator: GIFIndicator? { get set }
    func startActivityIndicator(message: String?)
    func stopActivityIndicator()
}
