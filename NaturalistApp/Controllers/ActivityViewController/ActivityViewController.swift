//
//  ActivityViewController.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 12/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, ObservationDetailProtocol, StoryboardInstantiable {
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
    var observation: Observation!
    var activityFeed: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        tableSizeConstaint.constant = CGFloat(160 * activityFeed.count)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityFeed.count * 3 - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row / 3
        switch indexPath.row % 3 {
        case 0:
            let cell = tableView.dequeueReusableCell(of: ActivityProfileTableViewCell.self, for: indexPath)
            cell.setup(activity: activityFeed[row], delegate: self)
            return cell
        case 1:
            switch activityFeed[row] {
            case .ident(let ident):
                let cell = tableView.dequeueReusableCell(of: ActivityTaxaTableViewCell.self, for: indexPath)
                cell.setup(taxon: ident.taxon, delegate: self)
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
