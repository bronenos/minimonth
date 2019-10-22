//
//  WidgetMeta.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class WidgetController: ObservableObject {
    @Published var meta: WidgetMeta
    
    private let calendar = Calendar.autoupdatingCurrent
    private var anchorDate = Date()
    
    init() {
        meta = calculateMeta(calendar: calendar, anchorDate: anchorDate)
    }
}

fileprivate func calculateMeta(calendar: Calendar, anchorDate: Date) -> WidgetMeta {
    let calendarUnits: Set<Calendar.Component> = [.year, .month, .weekday, .day, .weekOfMonth, .weekOfYear]
    let todayUnits = calendar.dateComponents(calendarUnits, from: Date())
    let anchorDayUnits = calendar.dateComponents(calendarUnits, from: anchorDate)
    
    let anchorMonthIndex = anchorDayUnits.month ?? 0
    let localWeekDay = calendar.unitToReal(weekday: anchorDayUnits.weekday ?? 0)
    let monthDay = anchorDayUnits.day ?? 0
    let monthWeek = anchorDayUnits.weekOfMonth ?? 0
    let startWeekday = calendar.monthOffset(day: monthDay, weekDay: localWeekDay)

    let monthlyWeeks = calendar.range(of: .weekOfMonth, in: .month, for: anchorDate) ?? 0..<1
    let yearlyWeeks = calendar.range(of: .weekOfYear, in: .month, for: anchorDate) ?? 0..<1
    let monthlyDays = calendar.range(of: .day, in: .month, for: anchorDate) ?? 0..<1
    
    let monthTitle = calendar.standaloneMonthSymbols[anchorMonthIndex - 1]
    let monthOffset = startWeekday - 1
    
    return WidgetMeta(
        monthTitle: monthTitle,
        weekNumbers: yearlyWeeks,
        weekdayTitles: calendar.sortedWeekdayShortTitles,
        monthOffset: monthOffset,
        days: monthlyDays.map { number in
            WidgetDay(
                number: number,
                type: .regular,
                options: []
            )
        }
    )
}

fileprivate extension Calendar {
    var sortedWeekdayShortTitles: [String] {
        let titles = shortStandaloneWeekdaySymbols
        let firstSlice = Array(titles[(firstWeekday - 1) ..< titles.count])
        let secondSlice = Array(titles[0 ..< firstWeekday])
        return firstSlice + secondSlice
    }
    
    func unitToReal(weekday: Int) -> Int {
        let value = weekday - (firstWeekday - 1)
        return (value < 1 ? value + weekdaySymbols.count : value)
    }
    
    func monthOffset(day: Int, weekDay: Int) -> Int {
        var calculatingDay = day
        var calculatingWeekday = weekDay
        
        while calculatingDay > 1 {
            calculatingDay -= 1
            calculatingWeekday = calculatingWeekday > 1 ? calculatingWeekday - 1 : weekdaySymbols.count
        }
        
        return calculatingWeekday
    }
}
