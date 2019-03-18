//
//  PhotoViewController.swift
//  PhotoViewController
//
//  Created by Dmitriy Borovikov on 15/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlConstraint: NSLayoutConstraint!
    private var scollViewIsDragging = false
    
    public var photos: [Photo] = []
    public var captions: [String] = []
    public var imageContentMode = UIView.ContentMode.scaleAspectFit
    private var pageControlConstraintConstant: CGFloat = 0
    
    public func refreshData() {
        pageControl.numberOfPages = photos.count
        pageControlConstraint.constant = captions.isEmpty ? 0 : pageControlConstraintConstant
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControlConstraintConstant = pageControlConstraint.constant
        pageControl.numberOfPages = photos.count
        pageControlConstraint.constant = captions.isEmpty ? 0 : pageControlConstraintConstant
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let visiblePage = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width
        coordinator.animate(alongsideTransition: { _ in
        }) { _ in
            let newOffset = CGPoint(x: visiblePage * self.collectionView.bounds.size.width, y: self.collectionView.contentOffset.y)
            self.collectionView.contentOffset = newOffset
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scollViewIsDragging = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scollViewIsDragging else { return }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    @IBAction func setPage(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        scollViewIsDragging = false
        collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let caption = captions.count > indexPath.row ? captions[indexPath.row] : nil
        cell.setup(url: photos[indexPath.row].mediumUrl, caption: caption, contentMode: imageContentMode)
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
