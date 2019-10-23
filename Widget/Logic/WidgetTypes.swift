//
//  WidgetTypes.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation

enum WidgetDayType {
    case regular
    case weekend
    case holiday
}

struct WidgetDayOptions: OptionSet, Hashable {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    
    static let none = WidgetDayOptions(rawValue: 0)
    static let isToday = WidgetDayOptions(rawValue: 1 << 0)
    static let hasEvent = WidgetDayOptions(rawValue: 1 << 1)
}

struct WidgetMeta: Hashable {
    let monthTitle: String
    let monthYear: Int?
    let weekNumbers: Range<Int>
    let weekdayTitles: [String]
    let monthOffset: Int
    let days: [WidgetDay]
}

struct WidgetDay: Hashable {
    let number: Int
    let type: WidgetDayType
    let options: WidgetDayOptions
}

struct WidgetDatestamp: Equatable {
    let year: Int
    let month: Int
    let day: Int
    
    init(year: Int?, month: Int?, day: Int?) {
        self.year = year ?? 0
        self.month = month ?? 0
        self.day = day ?? 0
    }
    
    init(components: DateComponents) {
        year = components.year ?? 0
        month = components.month ?? 0
        day = components.day ?? 0
    }
    
    init?(date: Date?, within calendar: Calendar) {
        guard let date = date else { return nil }
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
    }
}
