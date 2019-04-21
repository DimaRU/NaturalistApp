//
//  TaxaSearchViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 20/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import PromiseKit

class TaxaSearchViewController: UITableViewController {
    public var asset: PHAsset!
    private var searchResults: PagedResults<TaxonScore>?

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchComputerVision(for: asset)
    }

    private func fetchComputerVision(for asset: PHAsset) {
        firstly {
            PHImageManager.default().requestImageData(for: asset)
            }.then { data -> Promise<PagedResults<TaxonScore>> in
                guard let resource = PHAssetResource.assetResources(for: asset).first(where: { $0.type == .photo }) else {
                    throw PMKError.cancelled
                }
                let endpoint = NatAPI.scoreImage(image: data,
                                                 type: resource.uniformTypeIdentifier,
                                                 name: resource.originalFilename,
                                                 date: asset.creationDate ?? Date(),
                                                 location: asset.location?.coordinate)
                return NatProvider.shared.request(endpoint)
            }.done { result in
                self.searchResults = result
                self.tableView.reloadData()
            }.catch { error in
                print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.results.content.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: AddObservationTaxaTableViewCell.self, for: indexPath)
        let taxon = searchResults?.results.content[indexPath.row].taxon
        cell.setup(taxon: taxon)
        return cell
    }




}
