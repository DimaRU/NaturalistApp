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

protocol TaxaSearchViewProtocol {
    func selected(_ taxon: Taxon)
}

class TaxaSearchViewController: UIViewController {
    public var asset: PHAsset!
    public var delegate: TaxaSearchViewProtocol?
    public var observedOn: Date!
    public var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var taxonImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchResults: PagedResults<TaxonScore>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchComputerVision(for: asset)
    }
    
    private func fetchComputerVision(for asset: PHAsset) {
        let size = taxonImage.bounds.size
        firstly {
            PHImageManager.default().requestPreviewImage(for: asset, itemSize: size)
            }.then { (image, asset) -> Promise<(Data, String)> in
                self.taxonImage.image = image
                return PHImageManager.default().requestImageData(for: asset)
            }.then { (data, uti) -> Promise<(Data, String)> in
                if uti == "public.heic" {
                    guard let image = UIImage(data: data),
                        let jpgData = image.jpegData(compressionQuality: 0.8) else {
                        throw PMKError.cancelled
                    }
                    return Promise.value((jpgData, "public.jpeg"))
                } else {
                    return Promise.value((data, uti))
                }
            }.then { (data, uti) -> Promise<PagedResults<TaxonScore>> in
                guard let resource = PHAssetResource.assetResources(for: asset).first(where: { $0.type == .photo }) else {
                    throw PMKError.cancelled
                }
                let endpoint = NatAPI.scoreImage(image: data,
                                                 type: uti,
                                                 name: resource.originalFilename,
                                                 date: self.observedOn,
                                                 location: self.location)
                return NatProvider.shared.request(endpoint)
            }.done { result in
                self.searchResults = result
                self.tableView.reloadData()
            }.catch { error in
                print(error)
        }
    }
}

// MARK: - Table view data source
extension TaxaSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchResults?.commonAncestor == nil ? 1: 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchResults = searchResults else { return 0 }
        switch section {
        case 1:
            return searchResults.commonAncestor == nil ? searchResults.results.content.count : 1
        default:
            return searchResults.results.content.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: AddObservationTaxaTableViewCell.self, for: indexPath)
        switch indexPath.section {
        case 1:
            if let taxon = searchResults?.commonAncestor?.taxon {
                cell.setup(taxon: taxon)
            } else {
                fallthrough
            }
        default:
            let taxon = searchResults?.results.content[indexPath.row].taxon
            cell.setup(taxon: taxon)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taxon = getTaxon(for: indexPath)
        delegate?.selected(taxon)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let taxon = getTaxon(for: indexPath)
        let vc = TaxonDetailViewController()
        vc.observationCoordinate = location
        vc.taxon = taxon
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getTaxon(for indexPath: IndexPath) -> Taxon {
        switch indexPath.section {
        case 1:
            if let taxon = searchResults?.commonAncestor?.taxon {
                return taxon
            }
            fallthrough
        default:
            return searchResults!.results.content[indexPath.row].taxon
        }
    }
}
