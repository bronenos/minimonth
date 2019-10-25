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
    static let hasEvent = CalendarDayOptions(rawValue: 1 << 1)
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

struct CalendarDatestamp: Equatable {
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
