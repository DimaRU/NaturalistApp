//
//  ObservationDetailsViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

class ObservationDetailsViewController: UITableViewController, StoryboardInstantiable {
    enum CellTypeList: Int, CaseIterable {
        case profile = 0
        case photo
        case taxa
        case fave
    
        init(indexPath: IndexPath) {
            switch indexPath.row {
            case 0: self = .profile
            case 1: self = .photo
            case 2: self = .taxa
            case 3: self = .fave
            default:
                fatalError()
            }
        }
        var indexPath: IndexPath {
            return IndexPath(row: self.rawValue, section: 0)
        }
    }
    
    var observation: Observation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadObservation()
    }

    func loadObservation() {
        firstly {
            // start
            NatProvider.shared.request(.observation(id: observation.id))
            }.done { (pagedResult: PagedResults<Observation>) in
                self.observation = pagedResult.results.content.first
                self.tableView.reloadData()
            }.catch { error in
                print(error)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observation != nil ? CellTypeList.allCases.count : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellTypeList(indexPath: indexPath) {
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
            cell.setup(observation: observation)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: ", indexPath.row)
        switch CellTypeList(indexPath: indexPath) {
        case .profile:
            return
        case .photo:
            return
        case .taxa:
            return
        case .fave:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch CellTypeList(indexPath: indexPath) {
        case .profile, .taxa:
            return true
        case .photo, .fave:
            return false
        }
    }
    
    @IBAction func favoriteListTap(_ sender: UITapGestureRecognizer) {
        print("Show faved users tap")
    }
    
    @IBAction func faveStartTap(_ sender: UITapGestureRecognizer) {
        print("Add/remove fave")
        let endpoint: NatAPI = observation.favedByMe ? .unfave(id: observation.id) : .fave(id: observation.id)
        NatProvider.shared.request(endpoint)
            .done { (observation: Observation) in
                self.observation = observation
                self.tableView.reloadRows(at: [CellTypeList.fave.indexPath], with: .none)
            }.catch { error in
                print(error)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
