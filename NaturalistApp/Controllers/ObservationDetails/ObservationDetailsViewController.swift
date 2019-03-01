//
//  ObservationDetailsViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

class ObservationDetailsViewController: UITableViewController {
    var observationId: ObservationId!
    private var observation: Observation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadObservation()
    }

    func loadObservation() {
        firstly {
            // start
            NatProvider.shared.request(.observation(id: observationId))
            }.done { (pagedResult: PagedResults<Observation>) in
                self.observation = pagedResult.results.content.first
                self.tableView.reloadData()
            }.ensure {
                // end 
            }.catch { error in
                print(error)
//                self.navigationController?.dismiss(animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observation != nil ? 4 : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(of: ObservationProfilleTableViewCell.self, for: indexPath)
            cell.setup(observation: observation!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(of: ObservationPhotoTableViewCell.self, for: indexPath)
            cell.setup(observation: observation!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(of: ObservationTaxaTableViewCell.self, for: indexPath)
            cell.setup(observation: observation!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(of: ObservationFaveTableViewCell.self, for: indexPath)
            cell.setup(observation: observation!)
            return cell
        default:
            fatalError()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            return
        case 2:
            return
        case 3:
            return
        default:
            fatalError()
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
