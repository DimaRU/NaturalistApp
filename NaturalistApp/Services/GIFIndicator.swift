//
//  GIFIndicator.swift
//  TestActivityIndicator
//
//  Created by Dmitriy Borovikov on 29/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

public class GIFIndicator: UIView {
    var imageView: UIImageView
    var messageLabel: UILabel
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        messageLabel = UILabel()
        super.init(frame: frame)

        setupViews()
    }
    
    private func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32)
            ])
        
        imageView.animationFromGif(resource: "animated-tree")
        imageView.contentMode = .scaleAspectFit
        imageView.animationDuration = 2
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        messageLabel.font = .systemFont(ofSize: 19)
        messageLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageView = UIImageView()
        messageLabel = UILabel()
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    public func startAnimating(message: String? = nil)
    {
        messageLabel.text = message
        imageView.startAnimating()
    }
    
    public func stopAnimating() {
        imageView.stopAnimating()
    }

}
