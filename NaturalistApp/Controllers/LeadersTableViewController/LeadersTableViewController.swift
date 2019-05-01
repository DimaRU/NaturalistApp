//
//  LeadersTableViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 18/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class LeadersTableViewController: UIViewController, IndicateStateProtocol {
    var activityIndicator: GIFIndicator?
    @IBOutlet weak var tableView: UITableView!
    public var taxonIds: [TaxonId] = []
    private var observers: [Observer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPage()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchPage), for: .valueChanged)
    }
    
    @objc private func fetchPage() {
        tableView.isHidden = true
        if !(tableView.refreshControl?.isRefreshing ?? false) {
            startActivityIndicator(message: NSLocalizedString("Loading...", comment: ""))
        }
        let target = NatAPI.observers(perPage: 500, page: 1, taxonIds: taxonIds, observationId: nil, userId: nil)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observer>) in
                self.observers = pagedResult.results.content
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }.ensure {
                if self.tableView.refreshControl?.isRefreshing ?? false {
                    self.tableView.refreshControl?.endRefreshing()
                } else {
                    self.stopActivityIndicator()
                }
            }.catch{ error in
                self.showAlert(error: error)
            }
    }

}

extension LeadersTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(of: LeadersTableViewCell.self, for: indexPath)
        let row = indexPath.row
        let observer = observers[row]
        cell.observationsCountLabel.text = "Observations: ".localizedString + String(observer.observationCount)
        cell.speciesCountLabel.text = "Species: ".localizedString + String(observer.speciesCount)
        cell.userNameLabel.text = observer.user.login
        cell.avatarImageView.kf.setImage(with: observer.user.icon,
                                    placeholder: UIImage(named: "IC Account Circle 24px")?.maskWith(color: .lightGray))
        cell.rankLabel.text = String(row + 1)
        return cell
    }
    
    
}

extension LeadersTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileCollectionViewController.instantiate()
        vc.user = observers[indexPath.row].user
        navigationController?.pushViewController(vc, animated: true)
    }
}
