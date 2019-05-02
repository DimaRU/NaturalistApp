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

class AddObservationViewController: UIViewController, MainStoryboardInstantiable, IndicateStateProtocol {
    var activityIndicator: GIFIndicator?
    private var assets: [PHAsset] = []
    private var mainAsset: PHAsset?
    private var pickPhotoController: PickPhotoController!
    private var observationTableController: AddObservationTableViewController!
    

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = GIFIndicator()
        activityIndicator?.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        pickPhotoController = (children.first as! PickPhotoController)
        observationTableController = (children.last as! AddObservationTableViewController)
        pickPhotoController.delegate = self
    }

    @IBAction func shareButtonTap(_ sender: Any) {
        guard !assets.isEmpty else {
            let title = NSLocalizedString("No Photos", comment: "")
            let msg = NSLocalizedString("Without at least one photo, this observation will be impossible for others to help identify.", comment: "")
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(alert, animated: true)
            return
        }
        let target = observationTableController.createRequest()
        guard let target1 = target else { return }
        startActivityIndicator(message: "Upload observation...")
        NatProvider.shared.request(target1)
            .then { (observation: Observation) -> Promise<[PhotoPost]> in
                let promises = (0..<self.assets.count).map { position in
                    self.pushPhoto(asset: self.assets[position], id: observation.id, position: position)
                }
                return when(fulfilled: promises.makeIterator(), concurrently: 1)
            }.done { photos in
                self.dismiss(animated: true)
            }.ensure {
                self.stopActivityIndicator()
            }.catch { error in
                self.showAlert(error: error)
        }
    }

    private func pushPhoto(asset: PHAsset, id: ObservationId, position: Int) -> Promise<PhotoPost> {
        return PHImageManager.default().requestImageData(for: asset)
            .then { (data, uti) -> Promise<(Data, String)> in
                if uti == "public.heic" {
                    guard let image = UIImage(data: data),
                        let jpgData = image.jpegData(compressionQuality: 0.8) else {
                            throw InternalError.convertImage
                    }
                    return Promise.value((jpgData, "public.jpeg"))
                } else {
                    return Promise.value((data, uti))
                }
            }.then { data, uti in
                NatProvider.shared.request(NatAPI.postPhoto(image: data, observationId: id, type: uti, position: position))
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
