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

    var userId: UserId!
    var userProfile: User?
    private var observations: [Int:[Observation]] = [:]
    var totalResults = 0
    var perPage = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userId != Globals.currentUserId {
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
        let target = NatAPI.searchObservations(page: page, userId: userId, havePhoto: true, poular: nil)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observation>) in
                print(pagedResult.page, pagedResult.perPage, pagedResult.totalResults)
                
                let observations = pagedResult.results.content
                let fetchedCount = (pagedResult.page - 1) * pagedResult.perPage + observations.count
                if pagedResult.page == 1 {
                    self.collectionView.reloadData()
                } else {
                }
                guard fetchedCount < pagedResult.totalResults else { return }
                self.fetchObservationsPage(page: pagedResult.page + 1)
            }.ignoreErrors()
        
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
        
        let observation = observations[1]?[indexPath.row]
        cell.imageView.kf.setImage(with: observation?.photos.first?.squareUrl)
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: String(describing: ProfileHeaderCollectionReusableView.self),
                                                                   for: indexPath) as! ProfileHeaderCollectionReusableView
        if let user = userProfile {
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
        let itemWidth = UIScreen.main.bounds.width / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 86)
    }
    
}
