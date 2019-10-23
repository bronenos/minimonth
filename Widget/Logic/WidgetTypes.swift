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
