/////
////  IndicateStateProtocol.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

protocol IndicateStateProtocol: AnyObject {
    var activityIndicator: GIFIndicator? { get set }
    func startActivityIndicator(message: String?)
    func stopActivityIndicator()
    func showAlert(error: Error, completion: (() -> Void)?)
}
