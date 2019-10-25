//
//  PreferencesDriver.swift
//  Today
//
//  Created by Stan Potemkin on 24.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Combine

public protocol IPreferencesDriver: class {
    var monthColorLight: UIColor { get set }
    var monthColorDark: UIColor { get set }
    var navigationColorLight: UIColor { get set }
    var navigationColorDark: UIColor { get set }
    var captionColorLight: UIColor { get set }
    var captionColorDark: UIColor { get set }
    var workdayColorLight: UIColor { get set }
    var workdayColorDark: UIColor { get set }
    var weekendColorLight: UIColor { get set }
    var weekendColorDark: UIColor { get set }
    var holidayColorLight: UIColor { get set }
    var holidayColorDark: UIColor { get set }
    var todayColorLight: UIColor { get set }
    var todayColorDark: UIColor { get set }
    var eventColorLight: UIColor { get set }
    var eventColorDark: UIColor { get set }
    var weeknumDisplay: Bool { get set }
}

public final class PreferencesDriver: IPreferencesDriver, ObservableObject {
    public var objectWillChange = ObservableObjectPublisher()
    
    private let storage: UserDefaults
    
    private let defaultMonthColor = UIColor.label
    private let defaultNavigationColor = UIColor.label.withAlphaComponent(0.6)
    private let defaultCaptionColor = UIColor.secondaryLabel
    private let defaultWorkdayColor = UIColor.label
    private let defaultWeekendColor = UIColor.red
    private let defaultHolidayColor = UIColor.label
    private let defaultTodayColor = UIColor.systemGreen
    private let defaultEventColor = UIColor.systemRed
    
    public init() {
        storage = UserDefaults(suiteName: "group.V8NCXSZ3T7.me.bronenos.minimonth") ?? .standard
    }

    public var monthColorLight: UIColor {
        get { getColor(for: #function) ?? defaultMonthColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var monthColorDark: UIColor {
        get { getColor(for: #function) ?? defaultMonthColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationColorLight: UIColor {
        get { getColor(for: #function) ?? defaultNavigationColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationColorDark: UIColor {
        get { getColor(for: #function) ?? defaultNavigationColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var captionColorLight: UIColor {
        get { getColor(for: #function) ?? defaultCaptionColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var captionColorDark: UIColor {
        get { getColor(for: #function) ?? defaultCaptionColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var workdayColorLight: UIColor {
        get { getColor(for: #function) ?? defaultWorkdayColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var workdayColorDark: UIColor {
        get { getColor(for: #function) ?? defaultWorkdayColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendColorLight: UIColor {
        get { getColor(for: #function) ?? defaultWeekendColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendColorDark: UIColor {
        get { getColor(for: #function) ?? defaultWeekendColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var holidayColorLight: UIColor {
        get { getColor(for: #function) ?? defaultHolidayColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var holidayColorDark: UIColor {
        get { getColor(for: #function) ?? defaultHolidayColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var todayColorLight: UIColor {
        get { getColor(for: #function) ?? defaultTodayColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var todayColorDark: UIColor {
        get { getColor(for: #function) ?? defaultTodayColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var eventColorLight: UIColor {
        get { getColor(for: #function) ?? defaultEventColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var eventColorDark: UIColor {
        get { getColor(for: #function) ?? defaultEventColor }
        set { setColor(newValue, for: #function) }
    }
    
    public var weeknumDisplay: Bool {
        get { getBool(for: #function) }
        set { setBool(newValue, for: #function) }
    }
    
    public func resetAll() {
        monthColorLight = defaultMonthColor
        monthColorDark = defaultMonthColor
        navigationColorLight = defaultNavigationColor
        navigationColorDark = defaultNavigationColor
        captionColorLight = defaultCaptionColor
        captionColorDark = defaultCaptionColor
        workdayColorLight = defaultWorkdayColor
        workdayColorDark = defaultWorkdayColor
        weekendColorLight = defaultWeekendColor
        weekendColorDark = defaultWeekendColor
        todayColorLight = defaultTodayColor
        todayColorDark = defaultTodayColor
        eventColorLight = defaultEventColor
        eventColorDark = defaultEventColor
        weeknumDisplay = true
    }
    
    private func getColor(for key: String) -> UIColor? {
        return storage.object(forKey: key) as? UIColor
    }
    
    private func setColor(_ value: UIColor?, for key: String) {
        storage.set(value, forKey: key)
        
        storage.synchronize()
        objectWillChange.send()
    }
    
    private func getBool(for key: String) -> Bool {
        return storage.bool(forKey: key)
    }
    
    private func setBool(_ value: Bool, for key: String) {
        storage.set(value, forKey: key)
        
        storage.synchronize()
        objectWillChange.send()
    }
}
