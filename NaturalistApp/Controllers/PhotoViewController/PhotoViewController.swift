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
    private var scollViewIsDragging = false
    private var autoscrollTimer: Timer?
    
    public var photos: [Photo] = []
    public var captions: [String] = []
    public var imageContentMode = UIView.ContentMode.scaleAspectFit
    
    deinit {
        autoscrollTimer = nil
    }

    public func refreshData() {
        pageControl.numberOfPages = photos.count
        collectionView.reloadData()
        startAutoscroll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = photos.count
        startAutoscroll()
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
        stopAutoscroll()
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
        scollViewIsDragging = false
        stopAutoscroll()
        moveToPage(sender.currentPage)
    }
    
    private func moveToPage(_ page: Int) {
        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
    private func startAutoscroll() {
        guard autoscrollTimer == nil else { return }
        autoscrollTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
    }
    
    private func stopAutoscroll() {
        autoscrollTimer?.invalidate()
        autoscrollTimer = nil
    }
    
    @objc private func nextPage() {
        scollViewIsDragging = true
        var nextPage = pageControl.currentPage + 1
        if nextPage >= pageControl.numberOfPages {
            nextPage = 0
        }
        moveToPage(nextPage)
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

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stopAutoscroll()
        let vc = FullScreenViewController()
        vc.photo = photos[indexPath.row]
        let nc = FullScreenNavigationViewController(rootViewController: vc)
        present(nc, animated: true)
    }
}
