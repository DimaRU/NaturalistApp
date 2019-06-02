/////
////  PromiseKitExtensions.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import PromiseKit


extension Promise {

    @discardableResult
    func ignoreErrors() -> Promise<T> {
        self.catch { _ in }
        return self
    }
}
