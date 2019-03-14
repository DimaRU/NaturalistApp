//
//  DateExtensions.swift
//  HorizontalScroll
//
//  Created by Dmitriy Borovikov on 13/03/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

extension Date {
    func smartDatePeriod(to date: Date) -> String {
        let calendarComponents: Set<Calendar.Component> = [
            .minute,
            .hour,
            .day,
            .month,
            .year
        ]
        let components = Calendar.current.dateComponents(calendarComponents, from: self, to: date)
        
        if components.year ?? 0 > 0 {
            return String(components.year!) + "y"
        }
        if components.month ?? 0 > 0 {
            return String(components.month!) + "mo"
        }
        if components.day ?? 0 > 0 {
            return String(components.day!) + "d"
        }
        if components.hour ?? 0 > 0 {
            return String(components.hour!) + "h"
        }
        if components.minute ?? 0 > 0 {
            return String(components.minute!) + "min"
        }
        return "now"
    }
}
