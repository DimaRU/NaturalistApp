//
//  FullScreenViewController.swift
//  FullScreenViewController
//
//  Created by Joyce Echessa on 6/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import Kingfisher

class FullScreenViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    var photo: Photo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .white
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        scrollView.delegate = self
        addGestureRecognizers()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton(_:)))
        navigationItem.rightBarButtonItem = doneItem
        scrollView.addSubview(self.imageView)

        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = .lightGray
        scrollView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        imageView.kf.setImage(with: photo.originalUrl) { result in
            if case .success = result {
                self.activityIndicator.stopAnimating()
                self.imageView.sizeToFit()
                self.scrollView.contentSize = self.imageView.bounds.size
                self.setZoomScale()
                let yOffset = self.scrollView.frame.size.height - self.imageView.frame.size.height
                self.scrollView.contentOffset = CGPoint(x: 0, y: -yOffset / 2)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func tapDoneButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageSize = imageView.frame.size
        let scrollSize = scrollView.bounds.size
        
        let verticalPadding = imageSize.height < scrollSize.height ? (scrollSize.height - imageSize.height) / 2 : 0
        let horizontalPadding = imageSize.width < scrollSize.width ? (scrollSize.width - imageSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    func addGestureRecognizers() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        scrollView.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer) {
        navigationController?.navigationBar.isHidden.toggle()
        let isHidden = navigationController?.navigationBar.isHidden ?? true
        scrollView.backgroundColor = isHidden ? .black : .white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

extension FullScreenViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

