//
//  StackViewController.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 10/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

protocol StackViewControllerDelegate {
    func instantiate(type: NSObject.Type) -> NSObject?
    func reloadData(_ object: NSObject)
}

class StackViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var uiObjects: [NSObject] = []
    
    public var delegate: StackViewControllerDelegate?
    open var elements: [NSObject.Type] {
        return []
    }
    
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
    
    public func instantiateUI() {
        for element in elements {
            let object = delegate?.instantiate(type: element)
            switch object {
            case let object as UIView:
                add(object)
                uiObjects.append(object)
            case let object as UIViewController:
                add(object)
            case .none:
                break
            default:
                fatalError("Wrong object type")
            }
        }
    }
    
    public func reloadData() {
        uiObjects.forEach{ delegate?.reloadData($0) }
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
        uiObjects.append(child)
    }
    
    func remove(_ child: UIViewController) {
        guard child.parent != nil else { return }
        child.willMove(toParent: nil)
        stackView.removeArrangedSubview(child.view)
        child.view.removeFromSuperview()
        child.removeFromParent()
        uiObjects.removeAll(where: {$0 == child})
    }
}

extension StackViewController {
    func add(_ child: UIView) {
        stackView.addArrangedSubview(child)
        uiObjects.append(child)
    }
    
    func remove(_ child: UIView) {
        stackView.removeArrangedSubview(child)
        child.removeFromSuperview()
        uiObjects.removeAll(where: {$0 == child})
    }
}
