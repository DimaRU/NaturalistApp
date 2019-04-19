//
//  SheetPromise.swift
//  ActionSheetTest
//
//  Created by Dmitriy Borovikov on 04/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import PromiseKit

extension UIViewController {
    public func pickDate(title: String, datePicker: UIDatePicker) -> Promise<Date> {
        let (promise, seal) = Promise<Date>.pending()
        let sheetViewController = SheetViewController.sheet(title: title, sheetView: datePicker, done:
        { pickerView in
            let pickerView = pickerView as! UIDatePicker
            seal.fulfill(pickerView.date)
        }) {
            seal.reject(PMKError.cancelled)
        }
        self.present(sheetViewController, animated: true)
        return promise
    }

    public func pickValue<E: CaseIterable & Localizable>(title: String, initial: E?) -> Promise<E> {
        let (promise, seal) = Promise<E>.pending()
        let allCases = E.allCases.map{ $0.localized }
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let proxy = UIPickerViewProxy(allCases: allCases)
        pickerView.delegate = proxy
        if let initial = initial {
            pickerView.selectRow(allCases.firstIndex(of: initial.localized)!, inComponent: 0, animated: false)
        }
        let sheetViewController = SheetViewController.sheet(title: title, sheetView: pickerView, done: { pickerView in
            var selected = (pickerView as! UIPickerView).selectedRow(inComponent: 0)
            var iterator = E.allCases.makeIterator()
            while selected > 0 {
                let _ = iterator.next()
                selected -= 1
            }
            seal.fulfill(iterator.next()!)
            proxy.retainCycle = nil
        }) {
            seal.reject(PMKError.cancelled)
            proxy.retainCycle = nil
        }
        self.present(sheetViewController, animated: true)
        return promise
    }
}

class UIPickerViewProxy: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    let allCases: [String]
    var retainCycle: AnyObject?

    init(allCases: [String]) {
        self.allCases = allCases
        super.init()
        retainCycle = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCases[row]
    }
}
