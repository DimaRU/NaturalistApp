//
//  StackViewController.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 10/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    public var spacing: CGFloat {
        get { return stackView.spacing }
        set { stackView.spacing = newValue }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        setupConstraints()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.box(item1: scrollView, in: view.safeAreaLayoutGuide)
        NSLayoutConstraint.box(item1: stackView, in: scrollView)
        stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
}

extension StackViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(_ child: UIViewController) {
        guard child.parent != nil else { return }
        child.willMove(toParent: nil)
        stackView.removeArrangedSubview(child.view)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

extension StackViewController {
    func add(_ child: UIView) {
        stackView.addArrangedSubview(child)
    }
    
    func remove(_ child: UIView) {
        stackView.removeArrangedSubview(child)
        child.removeFromSuperview()
    }
}
