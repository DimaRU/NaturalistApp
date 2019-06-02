/////
////  SheetPromise.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
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

    public func pickValue<E>(title: String, initial: E?) -> Promise<E> where
        E: CaseIterable, E: Localizable, E.AllCases.Index == Int, E: Equatable {
        let (promise, seal) = Promise<E>.pending()
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let proxy = UIPickerViewProxy(E.self)
        pickerView.delegate = proxy
        if let initial = initial {
            let index = E.allCases.firstIndex(where: { $0 == initial })!
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        let sheetViewController = SheetViewController.sheet(title: title, sheetView: pickerView, done: { pickerView in
            let selected = (pickerView as! UIPickerView).selectedRow(inComponent: 0)
            seal.fulfill(E.allCases[selected])
            proxy.retainCycle = nil
        }) {
            seal.reject(PMKError.cancelled)
            proxy.retainCycle = nil
        }
        self.present(sheetViewController, animated: true)
        return promise
    }
}

class UIPickerViewProxy<E>: NSObject, UIPickerViewDelegate, UIPickerViewDataSource where
E: CaseIterable, E: Localizable, E.AllCases.Index == Int {
    var retainCycle: AnyObject?

    init(_ type: E.Type) {
        super.init()
        retainCycle = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return E.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return E.allCases[row].localized
    }
}
