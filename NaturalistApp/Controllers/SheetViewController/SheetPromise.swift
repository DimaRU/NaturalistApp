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
}
