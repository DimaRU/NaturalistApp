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
        vc = PhotoViewController.instantiate()
        vc = ProfileCollectionViewController.instantiate()
        vc = TaxonMapViewController.instantiate()
        vc = NatTabBarController.instantiate()
        print(vc.description)
    }

    func testViewNibInstantiable() {
        var view: UIView
        view = ObservationProfileView.instantiate()
        view = ObservationPhotoView.instantiate()
        view = ObservationTaxaView.instantiate()
        view = ObservationDescription.instantiate()
        view = ObservationFaveView.instantiate()
        view = TaxonWebContentView.instantiate()
        view = TaxonMapheaderView.instantiate()
        print(view.description)
    }
}
