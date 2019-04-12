//
//  SheetViewController.swift
//  ActionSheetTest
//
//  Created by Dmitriy Borovikov on 03/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit

class SheetViewController: UIViewController, StoryboardInstantiable {
    private var isPresenting = false
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sheetContainerView: UIView!
    
    private var barTitle: String?
    private var sheetView: UIView!
    private var done: ((UIView) -> Void)?
    private var cancel: (() -> Void)?

    static func sheet(title: String,
                      sheetView: UIView,
                      done: @escaping (UIView) -> Void,
                      cancel: (() -> Void)? = nil) -> SheetViewController {
        let sheetViewController = SheetViewController.instantiate()

        sheetViewController.title = title
        sheetViewController.sheetView = sheetView
        sheetViewController.done = done
        sheetViewController.cancel = cancel
        return sheetViewController
    }
    
    override func awakeFromNib() {
        modalPresentationStyle = .overCurrentContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.01)
        titleLabel.text = barTitle
        sheetContainerView.addSubview(sheetView)
        
        NSLayoutConstraint.activate([
            sheetContainerView.topAnchor.constraint(equalTo: sheetView.topAnchor),
            sheetContainerView.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor),
            sheetContainerView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            sheetContainerView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor)
            ])
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancel?()
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonTap(_ sender: Any) {
        done?(sheetView)
        dismiss(animated: true)
    }
}
