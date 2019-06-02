/////
////  ActivityViewController.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, ObservationDetailProtocol, StoryboardInstantiable, IndicateStateProtocol {
    var activityIndicator: GIFIndicator?
    let zero = CGFloat.leastNonzeroMagnitude
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableSizeConstaint: NSLayoutConstraint!
    enum Activity {
        case ident(ident: Identification)
        case comment(comment: Comment)
        
        var creationDate: Date {
            switch self {
            case .ident(let ident):
                return ident.createdAt
            case .comment(let comment):
                return comment.createdAt
            }
        }
        var user: User {
            switch self {
            case .ident(let ident):
                return ident.user
            case .comment(let comment):
                return comment.user
            }
        }
    }
    enum Section: Int, CaseIterable {
        case taxon = 0, description, fave, activity
    }
    
    var observation: Observation!
    var activityFeed: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        tableSizeConstaint.constant = CGFloat(160 * activityFeed.count)
        tableView.sectionHeaderHeight = 0
        let rect = CGRect(x: 0, y: 0, width: 0, height: zero)
        tableView.tableHeaderView = UIView(frame: rect)
        tableView.tableFooterView = UIView(frame: rect)
    }
    
    private func prepareData() {
        activityFeed = observation.identifications.map { Activity.ident(ident: $0) }
        let comments = observation.comments.map { Activity.comment(comment: $0) }
        activityFeed.append(contentsOf: comments)
        
        activityFeed.sort{ $0.creationDate < $1.creationDate }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.layoutIfNeeded()
        self.tableSizeConstaint.constant = self.tableView.contentSize.height
    }
    
}
extension ActivityViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .taxon:
            return observation.taxon == nil ? 0:1
        case .description:
            return (observation.description?.isEmpty ?? true) ? 0:1
        case .fave:
            return 1
        case .activity:
            guard !activityFeed.isEmpty else { return 0 }
            return activityFeed.count * 3 - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .taxon:
            let cell = tableView.dequeueReusableCell(of: TaxaTableViewCell.self, for: indexPath)
            cell.setup(taxon: observation.taxon)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(of: ObservationDescriptionTableViewCell.self, for: indexPath)
            cell.setup(description: observation.description)
            return cell
        case .fave:
            let cell = tableView.dequeueReusableCell(of: ObservationFaveTableViewCell.self, for: indexPath)
            cell.setup(observation: observation, delegate: self)
            return cell
        case .activity:
            let row = indexPath.row / 3
            switch indexPath.row % 3 {
            case 0:
                let cell = tableView.dequeueReusableCell(of: ActivityProfileTableViewCell.self, for: indexPath)
                cell.setup(activity: activityFeed[row])
                return cell
            case 1:
                switch activityFeed[row] {
                case .ident(let ident):
                    let cell = tableView.dequeueReusableCell(of: ActivityTaxaTableViewCell.self, for: indexPath)
                    cell.setup(taxon: ident.taxon)
                    return cell
                case .comment(let comment):
                    let cell = tableView.dequeueReusableCell(of: ActivityCommentTableViewCell.self, for: indexPath)
                    cell.setup(comment: comment)
                    return cell
                }
            case 2:
                return tableView.dequeueReusableCell(withIdentifier: "SeparatorCell", for: indexPath)
            default:
                fatalError()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch Section(rawValue: section)! {
        case .taxon:
            return observation.taxon == nil ? zero: 2
        case .description:
            return (observation.description?.isEmpty ?? true) ? zero: 2
        case .fave:
            return 2
        case .activity:
            return zero
        }
    }

}

extension ActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .taxon:
            guard let taxon = observation.taxon else { return }
            showTaxaDetails(taxon: taxon)
        case .description:
            break
        case .fave:
            break
        case .activity:
            let row = indexPath.row / 3
            switch indexPath.row % 3 {
            case 0:
                let user = activityFeed[row].user
                showUserProfile(user: user)
            case 1:
                if case .ident(let ident) = activityFeed[row] {
                    showTaxaDetails(taxon: ident.taxon)
                }
            default:
                break
            }
        }
    }
}

extension ActivityViewController: FaveChangeProtocol {
    func faveChange() {
        let endpoint: NatAPI = observation.favedByMe ? .unfave(id: observation.id) : .fave(id: observation.id)
        NatProvider.shared.request(endpoint)
            .done { (observation: Observation) in
                self.observation = observation
                let indexPath = IndexPath(row: 0, section: 2)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }.catch { error in
                self.showAlert(error: error)
        }
    }

}
