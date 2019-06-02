/////
////  DefaultCaseRepresentable.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

protocol DefaultCaseRepresentable: RawRepresentable, CaseIterable where RawValue: Equatable {
    static var defaultCase: Self { get }
}

extension DefaultCaseRepresentable {
    init(rawValue: RawValue) {
        self = Self.allCases.first(where: { $0.rawValue == rawValue }) ?? Self.defaultCase
    }
}
