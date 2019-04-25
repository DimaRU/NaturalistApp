//
//  LeadersTableViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 18/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class LeadersTableViewController: UIViewController, IndicateStateProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    public var taxonIds: [TaxonId] = []
    
    private var observers: [Observer] = []
    var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        fetchPage()
    }
    
    private func fetchPage() {
        showActivityIndicator()
        let target = NatAPI.observers(perPage: 500, page: 1, taxonIds: taxonIds, observationId: nil, userId: nil)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observer>) in
                print(pagedResult.page, pagedResult.perPage, pagedResult.totalResults)
                self.observers = pagedResult.results.content
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }.ensure {
                self.removeActivityIndicator()
            }
            .ignoreErrors()
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
