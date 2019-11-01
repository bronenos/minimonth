//
//  CalendarTypes.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation

public enum CalendarStyle {
    case month
    case week
}

struct CalendarMeta: Hashable {
    let monthTitle: String
    let monthYear: Int?
    let weekNumbers: Range<Int>
    let weekdayTitles: [String]
    let monthOffset: Int
    let days: [CalendarDay]
}

struct CalendarDay: Hashable {
    let number: Int
    let type: CalendarDayType
    let options: CalendarDayOptions
}

enum CalendarDayType {
    case regular
    case weekend
    case holiday
}

struct CalendarDayOptions: OptionSet, Hashable {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    
    static let none = CalendarDayOptions(rawValue: 0)
    static let isToday = CalendarDayOptions(rawValue: 1 << 0)
    static let hasLongEvent = CalendarDayOptions(rawValue: 1 << 1)
    static let hasShortEvent = CalendarDayOptions(rawValue: 1 << 2)
    
    func hasAnyEvent() -> Bool {
        return contains(.hasLongEvent) || contains(.hasShortEvent)
    }
}

enum CalendarNavigationStep {
    case backwardYear
    case backwardMonth
    case backwardWeek
    case forwardWeek
    case forwardMonth
    case forwardYear
}

enum CalendarAnimation {
    case styleChanged
}
