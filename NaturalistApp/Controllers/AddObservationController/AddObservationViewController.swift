//
//  AddObservationViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 13/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Photos
import PromiseKit

class AddObservationViewController: UIViewController, MainStoryboardInstantiable {
    private var assets: [PHAsset] = []
    private var mainAsset: PHAsset?
    private var pickPhotoController: PickPhotoController!
    private var observationTableController: AddObservationTableViewController!
    

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickPhotoController = (children.first as! PickPhotoController)
        observationTableController = (children.last as! AddObservationTableViewController)
        pickPhotoController.delegate = self
        authSession()
    }

    @IBAction func shareButtonTap(_ sender: Any) {
        print("Share")
    }

    private func authSession() {
        guard let bearer = KeychainService.shared[.bearer] else { return }
        NatProvider.shared.request(.apiToken(bearer: bearer))
            .then { (jwt: JWTToken) -> Promise<PagedResults<User>> in
                KeychainService.shared[.apiToken] = jwt.apiToken
                return NatProvider.shared.request(.currentUser)
            }.done { (paged: PagedResults<User>) -> Void in
                let user = paged.results.content.first!
                Globals.setCurrentUser(user: user)
                print(user.login, user.name ?? "")
            }.catch { error in
                print(error)
        }
    }

}

extension AddObservationViewController: PickPhotoControllerProtocol {
    func selected(assets: [PHAsset]) {
        self.assets = assets
        if mainAsset != assets.first {
            mainAsset = assets.first
            observationTableController.mainAsset = mainAsset
        }
    }
}
