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

final class WidgetMeta: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    private let calendar = Calendar.autoupdatingCurrent
    private var anchorDate = Date()
    
    func calculate() {
        let calendarUnits: Set<Calendar.Component> = [.year, .month, .weekday, .day, .weekOfMonth, .weekOfYear]
        let todayUnits = calendar.dateComponents(calendarUnits, from: Date())
        let focusDayUnits = calendar.dateComponents(calendarUnits, from: anchorDate)
        
        let focusedMonth = focusDayUnits.month ?? 0
        let localWeekDay = calculateRealWeekday(unitWeekday: focusDayUnits.weekday ?? 0)
        let monthDay = focusDayUnits.day ?? 0
        let monthWeek = focusDayUnits.weekOfMonth ?? 0
        let startWeekday = calculateWeekStart(day: monthDay, weekDay: localWeekDay)

        let monthlyWeeks = calendar.range(of: .weekOfMonth, in: .month, for: anchorDate)
        let yearlyWeeks = calendar.range(of: .weekOfYear, in: .month, for: anchorDate)
        let monthlyDays = calendar.range(of: .day, in: .month, for: anchorDate)
        
        let daysOffset = startWeekday - 1
    }
    
    private func calculateRealWeekday(unitWeekday: Int) -> Int {
        let wf = calendar.firstWeekday
        let wc = calendar.weekdaySymbols.count
        let ret = unitWeekday - (wf - 1)
        return (ret < 1 ? ret + wc : ret)
    }
    
    private func calculateWeekStart(day: Int, weekDay: Int) -> Int {
        let wc = calendar.weekdaySymbols.count
        
        var calculatingDay = day
        var calculatingWeekday = weekDay
        
        while calculatingDay > 1 {
            calculatingDay -= 1
            calculatingWeekday = calculatingWeekday > 1 ? calculatingWeekday - 1 : wc
        }
        
        return calculatingWeekday
    }
}
