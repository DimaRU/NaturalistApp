//
//  EditLocationOverlayView.swift
//  MapTest
//
//  Created by Dmitriy Borovikov on 24/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class EditLocationOverlayView: UIView {
    let color = UIColor.white.withAlphaComponent(0.75)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
    }
    
    func makeLabel(_ label: UILabel, rect: CGRect) -> UIView {
        let wrapper = UIView(frame: rect)
        wrapper.backgroundColor = color
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -5),
            label.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -5)
            ])
        return wrapper
    }
}
