//
//  NaturalistAppTests.swift
//  NaturalistAppTests
//
//  Created by Dmitriy Borovikov on 08/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import XCTest
@testable import NaturalistApp

class NaturalistAppTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testViewControllersInstantiable() {
        var vc: UIViewController
        vc = ActivityViewController.instantiate()
        vc = AddObservationViewController.instantiate()
        vc = PhotoViewController.instantiate()
        vc = ProfileCollectionViewController.instantiate()
        vc = SheetViewController.instantiate()
        vc = TaxonMapViewController.instantiate()
        vc = NatTabBarController.instantiate()
        vc = LoginViewController.instantiate()
        print(vc.description)
    }

    func testViewNibInstantiable() {
        var view: UIView
        view = ObservationProfileView.instantiate()
        view = ObservationTaxaView.instantiate()
        view = TaxonWebContentView.instantiate()
        view = TaxonMapheaderView.instantiate()
        print(view.description)
    }
}
