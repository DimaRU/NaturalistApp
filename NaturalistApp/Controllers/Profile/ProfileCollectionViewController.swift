//
//  ProfileCollectionViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 05/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

protocol ProfileDelegateProtocol: AnyObject {
    
}

class ProfileCollectionViewController: UICollectionViewController, StoryboardInstantiable, ProfileDelegateProtocol {

    var user: User?
    private var observations: [Int:[Observation]] = [:]
    var totalResults = 0
    var perPage = 20
    let elementsPerRow = 3
    var downloadingPages: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user?.id != Globals.currentUserId {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func tapLogOutButton(_ sender: UIBarButtonItem) {
        print("logout")
        self.performSegue(withIdentifier: "unwindToAuthorizeSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchObservationsPage(page: 1)
    }
    
    private func fetchObservationsPage(page: Int) {
        downloadingPages.insert(page)
        let target = NatAPI.searchObservations(page: page, userId: user?.id, havePhoto: true, poular: nil)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observation>) in
                print(pagedResult.page, pagedResult.perPage, pagedResult.totalResults)
                self.totalResults = pagedResult.totalResults
                self.observations[pagedResult.page] = pagedResult.results.content
                if pagedResult.page == 1 {
                    self.collectionView.reloadData()
                } else {
                    let startRow = pagedResult.page * self.perPage
                    let endRow = startRow + pagedResult.perPage
                    let paths = (startRow..<endRow).map { IndexPath(row: $0, section: 0)}
                    let visilePaths = self.collectionView.visibleIndexPaths(intersecting: paths)
                    self.collectionView.reloadItems(at: visilePaths)
                }
            }.ensure {
                self.downloadingPages.remove(page)
            }
            .ignoreErrors()
    }

    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalResults
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self),
                                                      for: indexPath) as! ImageCollectionViewCell
        
        let page = (indexPath.row / perPage) + 1
        let index = indexPath.row % perPage
        print("Request:", indexPath.row, page, index)
        if observations.keys.contains(page) {
            let observation = observations[page]?[index]
            cell.imageView.kf.setImage(with: observation?.photos.first?.squareUrl)
        } else if !downloadingPages.contains(page) {
            fetchObservationsPage(page: page)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: String(describing: ProfileHeaderCollectionReusableView.self),
                                                                   for: indexPath) as! ProfileHeaderCollectionReusableView
        if let user = user {
            view.isHidden = false
            view.configureData(user: user, delegate: self)
        } else {
            view.isHidden = true
        }
        return view
    }
}

extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width / CGFloat(elementsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 86)
    }
    
}
