//
//  ProfileCollectionViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 05/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

class ProfileCollectionViewController: UICollectionViewController, MainStoryboardInstantiable, IndicateStateProtocol {
    var activityIndicator: GIFIndicator?
    var user: User?
    private var observations: [Int:[Observation]] = [:]
    private var totalResults = 0
    private var downloadingPages: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.prefetchDataSource = self
        navigationItem.title = user?.login
            if user?.id != Globals.currentUserId {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchObservationsPage(page: 1)
    }

    private func fetchObservationsPage(page: Int) {
        downloadingPages.insert(page)
        let target = NatAPI.searchObservations(perPage: Params.perPage, page: page, userId: user?.id, havePhoto: true, poular: nil)
        NatProvider.shared.request(target)
            .done { (pagedResult: PagedResults<Observation>) in
                self.observations[pagedResult.page] = pagedResult.results.content
                if self.totalResults != pagedResult.totalResults {
                    self.totalResults = pagedResult.totalResults
                    self.collectionView.reloadData()
                } else {
                    let startRow = (pagedResult.page - 1) * Params.perPage
                    let endRow = startRow + pagedResult.perPage
                    let paths = (startRow..<endRow).map { IndexPath(row: $0, section: 0)}
                    let visiblePaths = self.collectionView.visibleIndexPaths(intersecting: paths)
                    self.collectionView.reloadItems(at: visiblePaths)
                }
                // Cleanup
                let min = self.downloadingPages.min()! - 5
                let max = self.downloadingPages.max()! + 5
                for key in self.observations.keys where key < min || key > max {
                    self.observations.removeValue(forKey: key)
                }
            }.ensure {
                self.downloadingPages.remove(page)
            }.catch { error in
                self.showAlert(error: error)
        }
    }
    
    private func checkFetchPage(for indexPath: IndexPath) {
        let page = (indexPath.row / Params.perPage) + 1
        if !observations.keys.contains(page) && !downloadingPages.contains(page) {
            fetchObservationsPage(page: page)
        }
    }

    private func getObservation(for indexPath: IndexPath) -> Observation? {
        let page = (indexPath.row / Params.perPage) + 1
        let index = indexPath.row % Params.perPage
        return observations[page]?[index]
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalResults
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: ImageCollectionViewCell.self, for: indexPath)

        let observation = getObservation(for: indexPath)
        cell.imageView.kf.setImage(with: observation?.photos.first?.squareUrl,
                                   placeholder: UIImage(named: "placeholder"))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: String(describing: ProfileHeaderCollectionReusableView.self),
                                                                   for: indexPath) as! ProfileHeaderCollectionReusableView
        if let user = user {
            view.isHidden = false
            view.configureData(user: user)
        } else {
            view.isHidden = true
        }
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let observation = getObservation(for: indexPath) else { return }

        let vc = ObservationDetailsViewController()
        vc.observation = observation
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach{ checkFetchPage(for: $0) }
    }
}

extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width / CGFloat(Params.elementsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 86)
    }
    
}

extension ProfileCollectionViewController {
    private struct Params {
        static let perPage = 30
        static let elementsPerRow = 3
    }
}
