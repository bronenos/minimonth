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
import EventKit

protocol IWidgetController: class {
    func requestEvents()
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
    
    private let calendar = Calendar.autoupdatingCurrent
    private let eventService: EventService
    private let delegate: WidgetDelegate?
    
    init(style: Style, delegate: WidgetDelegate?) {
        self.style = style
        self.delegate = delegate
        
        eventService = EventService(
            calendar: calendar,
            anchorDate: anchorDate
        )
        
        meta = calculateMeta(
            calendar: calendar,
            anchorDate: anchorDate,
            anchorEvents: anchorEvents,
            style: style
        )
        
        eventService.subscribe(
            eventsCallback: { [weak self] in self?.handleEvents($0) }
        )
    }
    
    func requestEvents() {
        eventService.request(anchorDate: anchorDate)
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
    
    private var style: Style {
        didSet { updateMeta() }
    }
    
    private var anchorDate = Date() {
        didSet { updateMeta(); requestEvents() }
    }
    
    private var anchorEvents: [EKEvent] = [] {
        didSet { updateMeta() }
    }
    
    private func updateMeta() {
        meta = calculateMeta(
            calendar: calendar,
            anchorDate: anchorDate,
            anchorEvents: anchorEvents,
            style: style
        )
        
        askToResize()
    }
    
    private func handleEvents(_ events: [EKEvent]) {
        anchorEvents = events
    }
}

fileprivate func calculateMeta(calendar: Calendar,
                               anchorDate: Date,
                               anchorEvents: [EKEvent],
                               style: WidgetController.Style) -> WidgetMeta {
    let calendarUnits: Set<Calendar.Component> = [.year, .month, .weekday, .day, .weekOfMonth, .weekOfYear]
    
    let todayUnits = calendar.dateComponents(calendarUnits, from: Date())
    let todayYear = todayUnits.year ?? 0
    
    let anchorDayUnits = calendar.dateComponents(calendarUnits, from: anchorDate)
    let anchorMonthIndex = anchorDayUnits.month ?? 0
    let anchorYear = anchorDayUnits.year ?? 0
    let ahcnorMonthTitle = calendar.standaloneMonthSymbols[anchorMonthIndex - 1]
    let anchorEventStamps = anchorEvents.compactMap { WidgetDatestamp(date: $0.startDate, within: calendar) }
    
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
                        anchorDayUnits: anchorDayUnits,
                        anchorEventStamps: anchorEventStamps
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
                        anchorDayUnits: anchorDayUnits,
                        anchorEventStamps: anchorEventStamps
                    )
                )
            }
        )
    }
}

fileprivate func calculateDayOptions(calendar: Calendar,
                                     anchorDate: Date,
                                     number: Int,
                                     anchorDayUnits: DateComponents,
                                     anchorEventStamps: [WidgetDatestamp]) -> WidgetDayOptions {
    let isToday: WidgetDayOptions
    if calendar.isDateInToday(anchorDate), number == anchorDayUnits.day {
        isToday = .isToday
    }
    else {
        isToday = .none
    }
    
    let anchorDatestamp = WidgetDatestamp(year: anchorDayUnits.year, month: anchorDayUnits.month, day: number)
    let hasEvent: WidgetDayOptions = anchorEventStamps.contains(anchorDatestamp) ? .hasEvent : .none

    return [isToday, hasEvent]
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
