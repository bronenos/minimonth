//
//  PreferencesDriver.swift
//  Today
//
//  Created by Stan Potemkin on 24.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation
import SwiftUI

protocol IPreferencesDriver: class {
    var monthColor: UIColor { get set }
    var navigationColor: UIColor { get set }
    var weekdayColor: UIColor { get set }
    var weeknumColor: UIColor { get set }
    var workdayColor: UIColor { get set }
    var weekendColor: UIColor { get set }
    var holidayColor: UIColor { get set }
    var todayColor: UIColor { get set }
    var eventColor: UIColor { get set }
    var weeknumDisplay: Bool { get set }
}

final class PreferencesDriver: IPreferencesDriver, ObservableObject {
    private let storage: UserDefaults
    
    private let defaultMonthColor = UIColor.label
    private let defaultNavigationColor = UIColor.label.withAlphaComponent(0.6)
    private let defaultWeekdayColor = UIColor.secondaryLabel
    private let defaultWeeknumColor = UIColor.secondaryLabel
    private let defaultWorkdayColor = UIColor.label
    private let defaultWeekendColor = UIColor.red
    private let defaultHolidayColor = UIColor.label
    private let defaultTodayColor = UIColor.systemGreen
    private let defaultEventColor = UIColor.systemRed

    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
    
    var monthColor: UIColor {
        get { getColor(for: #function) ?? defaultMonthColor }
        set { setColor(newValue, for: #function) }
    }
    
    var navigationColor: UIColor {
        get { getColor(for: #function) ?? defaultNavigationColor }
        set { setColor(newValue, for: #function) }
    }
    
    var weekdayColor: UIColor {
        get { getColor(for: #function) ?? defaultWeekdayColor }
        set { setColor(newValue, for: #function) }
    }
    
    var weeknumColor: UIColor {
        get { getColor(for: #function) ?? defaultWeeknumColor }
        set { setColor(newValue, for: #function) }
    }
    
    var workdayColor: UIColor {
        get { getColor(for: #function) ?? defaultWorkdayColor }
        set { setColor(newValue, for: #function) }
    }
    
    var weekendColor: UIColor {
        get { getColor(for: #function) ?? defaultWeekendColor }
        set { setColor(newValue, for: #function) }
    }
    
    var holidayColor: UIColor {
        get { getColor(for: #function) ?? defaultHolidayColor }
        set { setColor(newValue, for: #function) }
    }
    
    var todayColor: UIColor {
        get { getColor(for: #function) ?? defaultTodayColor }
        set { setColor(newValue, for: #function) }
    }
    
    var eventColor: UIColor {
        get { getColor(for: #function) ?? defaultEventColor }
        set { setColor(newValue, for: #function) }
    }
    
    var weeknumDisplay: Bool {
        get { getBool(for: #function) }
        set { setBool(newValue, for: #function) }
    }
    
    func resetAll() {
        monthColor = defaultMonthColor
        navigationColor = defaultNavigationColor
        weekdayColor = defaultWeekdayColor
        weeknumColor = defaultWeeknumColor
        workdayColor = defaultWorkdayColor
        weekendColor = defaultWeekendColor
        todayColor = defaultTodayColor
        eventColor = defaultEventColor
        weeknumDisplay = true
    }
    
    private func getColor(for key: String) -> UIColor? {
        return storage.object(forKey: key) as? UIColor
    }
    
    private func setColor(_ value: UIColor?, for key: String) {
        storage.set(value, forKey: key)
        storage.synchronize()
    }
    
    private func getBool(for key: String) -> Bool {
        return storage.bool(forKey: key)
    }
    
    private func setBool(_ value: Bool, for key: String) {
        storage.set(value, forKey: key)
        storage.synchronize()
    }
}
