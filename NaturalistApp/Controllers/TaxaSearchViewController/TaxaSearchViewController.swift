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

class TaxaSearchViewController: UIViewController, IndicateStateProtocol {
    var activityIndicator: GIFIndicator?
    public var asset: PHAsset!
    public var delegate: TaxaSearchViewProtocol?
    public var observedOn: Date!
    public var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var taxonImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchResults: PagedResults<TaxonScore>?
    private var creditNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.isHidden = true
        fetchComputerVision(for: asset)
    }
    
    private func fetchComputerVision(for asset: PHAsset) {
        startActivityIndicator(message: "Load iNaturalist suggestions...")
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
                        throw InternalError.convertImage
                    }
                    return Promise.value((jpgData, "public.jpeg"))
                } else {
                    return Promise.value((data, uti))
                }
            }.then { (data, uti) -> Promise<PagedResults<TaxonScore>> in
                guard let resource = PHAssetResource.assetResources(for: asset).first(where: { $0.type == .photo }) else {
                    throw InternalError.phasset
                }
                let endpoint = NatAPI.scoreImage(image: data,
                                                 type: uti,
                                                 name: resource.originalFilename,
                                                 date: self.observedOn,
                                                 location: self.location)
                return NatProvider.shared.request(endpoint)
            }.then { result -> Promise<Void> in
                self.searchResults = result
                var taxonIds: [TaxonId] = result.results.content.map{ $0.taxon.id }
                if let commonAncestor = result.commonAncestor {
                    taxonIds.insert(commonAncestor.taxon.id, at: 0)
                }
                if Bool.random() {
                    return NatProvider.shared.request(.observers(perPage: 3, page: 1, taxonIds: taxonIds, observationId: nil, userId: nil))
                        .then { (pagedResult: PagedResults<Observer>) -> Promise<Void> in
                            self.creditNames = pagedResult.results.content.map{ $0.user.name?.emptyToNil() ?? $0.user.login }
                            return Promise.value(())
                    }
                } else {
                    return NatProvider.shared.request(.identifiers(perPage: 3, page: 1, taxonIds: taxonIds, observationId: nil, userId: nil))
                        .then { (pagedResult: PagedResults<Identifier>) -> Promise<Void> in
                            self.creditNames = pagedResult.results.content.map{ $0.user.name?.emptyToNil() ?? $0.user.login }
                            return Promise.value(())
                    }
                }
            }.done {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }.ensure {
                self.stopActivityIndicator()
            }.catch { error in
                self.showAlert(error: error) {
                    self.navigationController?.popViewController(animated: true)
                }
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
        case 0:
            if searchResults.commonAncestor != nil {
                return 1
            }
            fallthrough
        default:
            return searchResults.results.content.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: TaxaSearchTableViewCell.self, for: indexPath)
        switch indexPath.section {
        case 0:
            if let taxon = searchResults?.commonAncestor?.taxon {
                cell.setupTaxon(taxon: taxon)
            } else {
                fallthrough
            }
        default:
            let taxonScore = searchResults!.results.content[indexPath.row]
            cell.setupScore(taxonScore: taxonScore)
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
        case 0:
            if let taxon = searchResults?.commonAncestor?.taxon {
                return taxon
            }
            fallthrough
        default:
            return searchResults!.results.content[indexPath.row].taxon
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let commonAncestor = searchResults?.commonAncestor {
            if section == 0 {
                let base = NSLocalizedString("We're pretty sure this is in the %1$@ %2$@.", comment: "comment for common ancestor suggestion. %1$@ is the rank name (order, family), whereas %2$@ is the actual rank (Animalia, Insecta)")
                return String(format: base, commonAncestor.taxon.rankName, commonAncestor.taxon.scientificName)
            } else {
                return NSLocalizedString("Here are our top ten species suggestions:", comment: "")
            }
        } else if (searchResults?.results.content.count ?? 0) > 0 {
            return NSLocalizedString("We're not confident enough to make a recommendation, but here are our top 10 suggestions.", comment: "")
        }
        return nil
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard (searchResults?.results.content.count ?? 0) > 0 else { return nil }
        if searchResults?.commonAncestor != nil, section == 0 {
            return nil
        } else {
            if !creditNames.isEmpty {
                let base = NSLocalizedString("Suggestions based on observations and identifications provided by the iNaturalist community, including %@ and many others.", comment: "")
                return String(format: base, creditNames.joined(separator: ", "))
            } else {
                return NSLocalizedString("Suggestions based on observations and identifications provided by the iNaturalist community.", comment: "")
            }
        }
    }

}
