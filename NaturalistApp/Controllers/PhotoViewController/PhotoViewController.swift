//
//  PhotoViewController.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 07/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    var photos: [Photo] = []
    
    @IBOutlet weak var photoStackView: UIStackView!
    @IBOutlet weak var photoPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViews = photos.compactMap { makePhotoView(for: $0.mediumUrl ) }
        imageViews.forEach{ photoStackView.addArrangedSubview($0) }
        photoPageControl.numberOfPages = imageViews.count
        photoPageControl.currentPage = 0
    }
    
    func makePhotoView(for url: URL) -> UIImageView? {
        guard let photo = try? Data(contentsOf: url) else { return nil }
        guard let photoImage = UIImage(data: photo) else { return nil }
        let imageView = UIImageView(image: photoImage)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 4.0/3.0).isActive = true
        return imageView
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let part = scrollView.contentOffset.x / scrollView.contentSize.width * CGFloat(photoPageControl.numberOfPages)
        let page = Int(part)
        photoPageControl.currentPage = page
    }
}
