//
//  ObservationDetailsViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

protocol ObservationDetailProtocol: AnyObject {
    func faveChange()
    func showFavedUsers()
}

class ObservationDetailsViewController: UITableViewController, StoryboardInstantiable {
    enum CellTypes: Int, CaseIterable {
        case profile = 0
        case photo
        case taxa
        case fave
    
        init(indexPath: IndexPath) {
            self.init(rawValue: indexPath.row)!
        }
        var indexPath: IndexPath {
            return IndexPath(row: self.rawValue, section: 0)
        }
    }
    
    var observation: Observation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        reLoadObservation()
    }

    func reLoadObservation() {
        firstly {
            // start
            NatProvider.shared.request(.observation(id: observation.id))
            }.done { (pagedResult: PagedResults<Observation>) in
                self.observation = pagedResult.results.content.first
                self.tableView.reloadData()
            }.ignoreErrors()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observation != nil ? CellTypes.allCases.count : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellTypes(indexPath: indexPath) {
        case .profile:
            let cell = tableView.dequeueReusableCell(of: ObservationProfilleTableViewCell.self, for: indexPath)
            cell.setup(observation: observation)
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(of: ObservationPhotoTableViewCell.self, for: indexPath)
            cell.photoImageView.kf.setImage(with: observation.photos.first?.mediumUrl) { _ in
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell
        case .taxa:
            let cell = tableView.dequeueReusableCell(of: ObservationTaxaTableViewCell.self, for: indexPath)
            cell.setup(observation: observation)
            return cell
        case .fave:
            let cell = tableView.dequeueReusableCell(of: ObservationFaveTableViewCell.self, for: indexPath)
            cell.setup(observation: observation, delegate: self)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: ", indexPath.row)
        switch CellTypes(indexPath: indexPath) {
        case .profile:
            let vc = ProfileCollectionViewController.instantiateFromMainStoryboard()
            vc.user = observation.user
            navigationController?.pushViewController(vc, animated: true)
            return
        case .taxa:
            #warning ("Todo: show taxon details")
            return
        case .photo, .fave:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch CellTypes(indexPath: indexPath) {
        case .profile, .taxa:
            return true
        case .photo, .fave:
            return false
        }
    }
    
}


extension ObservationDetailsViewController: ObservationDetailProtocol {
    func faveChange() {
        let endpoint: NatAPI = observation.favedByMe ? .unfave(id: observation.id) : .fave(id: observation.id)
        NatProvider.shared.request(endpoint)
            .done { (observation: Observation) in
                self.observation = observation
                self.tableView.reloadRows(at: [CellTypes.fave.indexPath], with: .none)
            }.ignoreErrors()
    }
    
    func showFavedUsers() {
        #warning ("Todo: Show faved users tap")
        print("Show faved users tap")
    }
}
