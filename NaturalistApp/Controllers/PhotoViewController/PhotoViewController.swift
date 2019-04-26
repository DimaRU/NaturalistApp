//
//  PhotoViewController.swift
//  PhotoViewController
//
//  Created by Dmitriy Borovikov on 15/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, StoryboardInstantiable {
    public struct Photo {
        let previewUrl: URL
        let fullSizeUrl: URL?
        let caption: String?
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    private var enablePageControlPaging = false
    private var autoscrollTimer: Timer?
    
    public var photos: [Photo] = []
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
        pageControl.clipsToBounds = true
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
        stopAutoscroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enablePageControlPaging = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enablePageControlPaging = true
        startAutoscroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoscroll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard enablePageControlPaging else { return }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    @IBAction func setPage(_ sender: UIPageControl) {
        stopAutoscroll()
        moveToPage(sender.currentPage)
    }
    
    private func moveToPage(_ page: Int) {
        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
    private func startAutoscroll() {
        guard autoscrollTimer == nil,
            pageControl.numberOfPages > 1 else { return }
        autoscrollTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
    }
    
    private func stopAutoscroll() {
        autoscrollTimer?.invalidate()
        autoscrollTimer = nil
    }
    
    @objc private func nextPage() {
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
        let photo = photos[indexPath.row]
        cell.setup(url: photo.previewUrl, caption: photo.caption, contentMode: imageContentMode)
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
        guard let url = photos[indexPath.row].fullSizeUrl else { return }
        let vc = FullScreenViewController()
        vc.photoUrl = url
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}
