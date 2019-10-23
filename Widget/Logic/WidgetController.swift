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

protocol IWidgetController: class {
    func toggle(style: WidgetController.Style)
    func switchToPreviousYear()
    func switchToPreviousMonth()
    func switchToCurrentMonth()
    func switchToNextMonth()
    func switchToNextYear()
}

final class WidgetController: IWidgetController, ObservableObject {
    enum Style {
        case month
        case week
    }
    
    @Published var meta: WidgetMeta
    
    private let delegate: WidgetDelegate?
    private let calendar = Calendar.autoupdatingCurrent
    
    private var style: Style {
        didSet { updateMeta() }
    }
    
    private var anchorDate = Date() {
        didSet { updateMeta() }
    }
    
    init(style: Style, delegate: WidgetDelegate?) {
        self.style = style
        self.delegate = delegate
        
        meta = calculateMeta(calendar: calendar, anchorDate: anchorDate, style: style)
    }
    
    func toggle(style: Style) {
        self.style = style
    }
    
    func switchToPreviousYear() {
        anchorDate = calendar.date(byAdding: .year, value: -1, to: anchorDate) ?? anchorDate
    }
    
    func switchToPreviousMonth() {
        anchorDate = calendar.date(byAdding: .month, value: -1, to: anchorDate) ?? anchorDate
    }
    
    func switchToCurrentMonth() {
        anchorDate = Date()
    }
    
    func switchToNextMonth() {
        anchorDate = calendar.date(byAdding: .month, value: 1, to: anchorDate) ?? anchorDate
    }
    
    func switchToNextYear() {
        anchorDate = calendar.date(byAdding: .year, value: 1, to: anchorDate) ?? anchorDate
    }
    
    func askToResize() {
        delegate?.resize()
    }
    
    private func updateMeta() {
        meta = calculateMeta(calendar: calendar, anchorDate: anchorDate, style: style)
        askToResize()
    }
}

fileprivate func calculateMeta(calendar: Calendar, anchorDate: Date, style: WidgetController.Style) -> WidgetMeta {
    let calendarUnits: Set<Calendar.Component> = [.year, .month, .weekday, .day, .weekOfMonth, .weekOfYear]
    
    let todayUnits = calendar.dateComponents(calendarUnits, from: Date())
    let todayYear = todayUnits.year ?? 0
    
    let anchorDayUnits = calendar.dateComponents(calendarUnits, from: anchorDate)
    let anchorMonthIndex = anchorDayUnits.month ?? 0
    let anchorYear = anchorDayUnits.year ?? 0
    let ahcnorMonthTitle = calendar.standaloneMonthSymbols[anchorMonthIndex - 1]
    
    let localWeekDay = calendar.unitToReal(weekday: anchorDayUnits.weekday ?? 0)
    let monthDay = anchorDayUnits.day ?? 0
    let startWeekday = calendar.monthOffset(day: monthDay, weekDay: localWeekDay)

    switch style {
    case .month:
        let yearlyWeeks = calendar.range(of: .weekOfYear, in: .month, for: anchorDate) ?? .empty
        let monthlyDays = calendar.range(of: .day, in: .month, for: anchorDate) ?? .empty
        let monthOffset = startWeekday - 1

        return WidgetMeta(
            monthTitle: ahcnorMonthTitle,
            monthYear: (anchorYear == todayYear ? nil : anchorYear),
            weekNumbers: yearlyWeeks,
            weekdayTitles: calendar.sortedWeekdayShortTitles,
            monthOffset: monthOffset,
            days: monthlyDays.map { number in
                WidgetDay(
                    number: number,
                    type: .regular,
                    options: calculateDayOptions(
                        calendar: calendar,
                        anchorDate: anchorDate,
                        number: number,
                        anchorDayUnits: anchorDayUnits
                    )
                )
            }
        )
        
    case .week:
        let yearlyWeeks = Range.only(anchorDayUnits.weekOfYear ?? 1)
        let monthlyDays = calendar.range(of: .day, in: .weekOfMonth, for: anchorDate) ?? .empty
        let monthOffset = (anchorDayUnits.weekOfMonth == 1 ? startWeekday - 1 : 0)

        return WidgetMeta(
            monthTitle: ahcnorMonthTitle,
            monthYear: (anchorYear == todayYear ? nil : anchorYear),
            weekNumbers: yearlyWeeks,
            weekdayTitles: calendar.sortedWeekdayShortTitles,
            monthOffset: monthOffset,
            days: monthlyDays.map { number in
                WidgetDay(
                    number: number,
                    type: .regular,
                    options: calculateDayOptions(
                        calendar: calendar,
                        anchorDate: anchorDate,
                        number: number,
                        anchorDayUnits: anchorDayUnits
                    )
                )
            }
        )
    }
}

fileprivate func calculateDayOptions(calendar: Calendar,
                                     anchorDate: Date,
                                     number: Int,
                                     anchorDayUnits: DateComponents) -> WidgetDayOptions {
    let isToday: WidgetDayOptions
    if calendar.isDateInToday(anchorDate), number == anchorDayUnits.day {
        isToday = .isToday
    }
    else {
        isToday = .none
    }

    return [isToday]
}

fileprivate extension Calendar {
    var sortedWeekdayShortTitles: [String] {
        let titles = shortStandaloneWeekdaySymbols
        let firstSlice = Array(titles[(firstWeekday - 1) ..< titles.count])
        let secondSlice = Array(titles[0 ..< firstWeekday - 1])
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
