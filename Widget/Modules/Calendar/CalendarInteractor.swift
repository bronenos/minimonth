//
//  CalendarController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import EventKit

protocol ICalendarInteractor: class {
    var style: CalendarStyle { get }
    var shouldAnimate: Bool { get }
    func requestEvents()
    func toggle(style: CalendarStyle)
    func navigateLongBackward()
    func navigateShortBackward()
    func navigateNowadays()
    func navigateShortForward()
    func navigateLongForward()
}

fileprivate struct CalendarEventMeta: Equatable {
    let year: Int
    let month: Int
    let day: Int
    let allDay: Bool

    init?(parseEvent event: EKEvent, within calendar: Calendar) {
        guard let date = event.startDate else { return nil }
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        allDay = event.isAllDay
    }
    
    init(year: Int?, month: Int?, day: Int?, allDay: Bool) {
        self.year = year ?? 0
        self.month = month ?? 0
        self.day = day ?? 0
        self.allDay = allDay
    }
    
    static func == (lhs: CalendarEventMeta, rhs: CalendarEventMeta) -> Bool {
        guard lhs.year == rhs.year else { return false }
        guard lhs.month == rhs.month else { return false }
        guard lhs.day == rhs.day else { return false }
        guard lhs.allDay == rhs.allDay else { return false }
        return true
    }
}

public final class CalendarInteractor: ICalendarInteractor, ObservableObject {
    @Published var meta: CalendarMeta
    
    private let calendar = Calendar.autoupdatingCurrent
    private let eventService: EventService
    
    private var lastAnimationDate: Date?
    private var eventsListener: AnyCancellable?
    
    public init(style: CalendarStyle) {
        self.style = style
        
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
        
        eventsListener = eventService.subscribe(
            eventsCallback: { [weak self] in self?.handleEvents($0) }
        )
        
        requestEvents()
    }
    
    var shouldAnimate: Bool {
        guard let date = lastAnimationDate else { return false }
        return (Date().timeIntervalSince(date) < 0.25)
    }
    
    func requestEvents() {
        eventService.request(anchorDate: anchorDate)
    }
    
    func toggle(style: CalendarStyle) {
        if let _ = lastAnimationDate {
            lastAnimationDate = Date()
        }
        else {
            lastAnimationDate = Date.distantPast
        }
        
        self.style = style
    }
    
    func navigateLongBackward() {
        guard let date = calendar.date(byAdding: .year, value: -1, to: anchorDate) else { return }
        anchorDate = date
    }
    
    func navigateShortBackward() {
        guard let firstDay = meta.days.first else { return }
        let anchorDayNumber = calendar.component(.day, from: anchorDate)
        let diff = anchorDayNumber - firstDay.number + 1
        
        guard let date = calendar.date(byAdding: .day, value: -diff, to: anchorDate) else { return }
        anchorDate = date
    }
    
    func navigateNowadays() {
        anchorDate = Date()
    }
    
    func navigateShortForward() {
        guard let lastDay = meta.days.last else { return }
        let anchorDayNumber = calendar.component(.day, from: anchorDate)
        let diff = lastDay.number - anchorDayNumber + 1
        
        guard let date = calendar.date(byAdding: .day, value: diff, to: anchorDate) else { return }
        anchorDate = date
    }
    
    func navigateLongForward() {
        guard let date = calendar.date(byAdding: .year, value: 1, to: anchorDate) else { return }
        anchorDate = date
    }
    
    private(set) var style: CalendarStyle {
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
    }
    
    private func handleEvents(_ events: [EKEvent]) {
        anchorEvents = events
    }
}

fileprivate func calculateMeta(calendar: Calendar,
                               anchorDate: Date,
                               anchorEvents: [EKEvent],
                               style: CalendarStyle) -> CalendarMeta {
    let calendarUnits: Set<Calendar.Component> = [.year, .month, .weekday, .day, .weekOfMonth, .weekOfYear]
    
    let todayUnits = calendar.dateComponents(calendarUnits, from: Date())
    let todayYear = todayUnits.year ?? 0
    
    let anchorDayUnits = calendar.dateComponents(calendarUnits, from: anchorDate).normalizedWeeknum(calendar: calendar)
    let anchorMonthIndex = anchorDayUnits.month ?? 0
    let anchorYear = anchorDayUnits.year ?? 0
    let ahcnorMonthTitle = calendar.standaloneMonthSymbols[anchorMonthIndex - 1].capitalized
    let anchorEventStamps = anchorEvents.compactMap { CalendarEventMeta(parseEvent: $0, within: calendar) }
    
    let localWeekDay = calendar.unitToReal(weekday: anchorDayUnits.weekday ?? 0)
    let monthDay = anchorDayUnits.day ?? 0
    let startWeekday = calendar.monthOffset(day: monthDay, weekDay: localWeekDay)

    switch style {
    case .month:
        let yearlyWeeks = calendar.range(of: .weekOfYear, in: .month, for: anchorDate) ?? .empty
        let anchorDays = calendar.range(of: .day, in: .month, for: anchorDate) ?? .empty
        let monthOffset = startWeekday.offset - 1

        return CalendarMeta(
            monthTitle: ahcnorMonthTitle,
            monthYear: anchorYear, // (anchorYear == todayYear ? nil : anchorYear),
            weekNumbers: yearlyWeeks,
            weekdayTitles: calendar.sortedWeekdayShortTitles,
            monthOffset: monthOffset,
            days: anchorDays.map { number in
                CalendarDay(
                    number: number,
                    type: detectMonthdayType(
                        calendar: calendar,
                        anchorDate: anchorDate,
                        anchorDay: anchorDayUnits.day ?? 1,
                        day: number
                    ),
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
        let monthOffset = (startWeekday.firstWeek ? startWeekday.offset - 1 : 0)

        return CalendarMeta(
            monthTitle: ahcnorMonthTitle,
            monthYear: anchorYear, // (anchorYear == todayYear ? nil : anchorYear),
            weekNumbers: yearlyWeeks,
            weekdayTitles: calendar.sortedWeekdayShortTitles,
            monthOffset: monthOffset,
            days: monthlyDays.map { number in
                CalendarDay(
                    number: number,
                    type: detectMonthdayType(
                        calendar: calendar,
                        anchorDate: anchorDate,
                        anchorDay: anchorDayUnits.day ?? 1,
                        day: number
                    ),
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

fileprivate func detectMonthdayType(calendar: Calendar,
                                    anchorDate: Date,
                                    anchorDay: Int,
                                    day: Int) -> CalendarDayType {
    guard let baseDate = calendar.date(
        byAdding: .day,
        value: -(anchorDay - 1),
        to: anchorDate,
        wrappingComponents: true) else { return .regular }
    
    guard let anotherDate = calendar.date(
        bySetting: .day,
        value: day,
        of: baseDate) else { return .regular }
    
    if calendar.isDateInWeekend(anotherDate) {
        return .weekend
    }
    else {
        return .regular
    }
}

fileprivate func calculateDayOptions(calendar: Calendar,
                                     anchorDate: Date,
                                     number: Int,
                                     anchorDayUnits adu: DateComponents,
                                     anchorEventStamps: [CalendarEventMeta]) -> CalendarDayOptions {
    let isToday: CalendarDayOptions = calendar.detectToday(units: adu, day: number) ? .isToday : .none
    let anchorLongMeta = CalendarEventMeta(year: adu.year, month: adu.month, day: number, allDay: true)
    let hasLongEvent: CalendarDayOptions = anchorEventStamps.contains(anchorLongMeta) ? .hasLongEvent : .none

    let anchorShortMeta = CalendarEventMeta(year: adu.year, month: adu.month, day: number, allDay: false)
    let hasShortEvent: CalendarDayOptions = anchorEventStamps.contains(anchorShortMeta) ? .hasShortEvent : .none

    return [isToday, hasShortEvent, hasLongEvent]
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
    
    func monthOffset(day: Int, weekDay: Int) -> (offset: Int, firstWeek: Bool) {
        var calculatingDay = day
        var calculatingWeekday = weekDay
        var firstWeek = true
        
        while calculatingDay > 1 {
            if calculatingWeekday == firstWeekday {
                firstWeek = false
            }
            
            calculatingDay -= 1
            calculatingWeekday = calculatingWeekday > 1 ? calculatingWeekday - 1 : weekdaySymbols.count
        }
        
        return (offset: calculatingWeekday, firstWeek: firstWeek)
    }
    
    func detectToday(units: DateComponents, day: Int) -> Bool {
        guard component(.year, from: Date()) == units.year else { return false }
        guard component(.month, from: Date()) == units.month else { return false }
        guard component(.day, from: Date()) == day else { return false }
        return true
    }
}

fileprivate extension DateComponents {
    func normalizedWeeknum(calendar: Calendar) -> DateComponents {
        if weekOfYear == 1, month != 1 {
            guard let originalDate = calendar.date(from: self) else { return self }
            guard let earlierDate = calendar.date(byAdding: .month, value: -1, to: originalDate) else { return self }
            guard let range = calendar.range(of: .weekOfYear, in: .year, for: earlierDate) else { return self }
            
            var c = self
            c.weekOfYear = range.count
            return c
        }
        else {
            return self
        }
    }
}
