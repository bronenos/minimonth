//
//  CalendarExtensions.swift
//  Today
//
//  Created by Stan Potemkin on 24.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation

extension Calendar {
    func numberOfDaysInWeek() -> Int {
        return weekdaySymbols.count
    }
    
    func numberOfDaysInMonth(anchorDate: Date) -> Int {
        return range(of: .day, in: .month, for: anchorDate)?.count ?? 1
    }
}
