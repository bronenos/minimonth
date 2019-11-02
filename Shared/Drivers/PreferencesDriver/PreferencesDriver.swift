//
//  PreferencesDriver.swift
//  Today
//
//  Created by Stan Potemkin on 24.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Combine

public typealias PreferencesReadableKeyPath = KeyPath<PreferencesDriver, UIColor>
public typealias PreferencesWritableKeyPath = ReferenceWritableKeyPath<PreferencesDriver, UIColor>

public protocol IPreferencesDriver: class {
    var monthTitleColorLight: UIColor { get set }
    var monthTitleColorDark: UIColor { get set }
    var navigationElementsColorLight: UIColor { get set }
    var navigationElementsColorDark: UIColor { get set }
    var weekCaptionsColorLight: UIColor { get set }
    var weekCaptionsColorDark: UIColor { get set }
    var workingDayColorLight: UIColor { get set }
    var workingDayColorDark: UIColor { get set }
    var weekendDayColorLight: UIColor { get set }
    var weekendDayColorDark: UIColor { get set }
    var currentDayColorLight: UIColor { get set }
    var currentDayColorDark: UIColor { get set }
    var shortEventColorLight: UIColor { get set }
    var shortEventColorDark: UIColor { get set }
    var alldayEventColorLight: UIColor { get set }
    var alldayEventColorDark: UIColor { get set }
    var shouldDisplayWeekNumbers: Bool { get set }
    func resetColors()
}

public final class PreferencesDriver: IPreferencesDriver, ObservableObject {
    public var objectWillChange = ObservableObjectPublisher()
    
    private let storage: UserDefaults
    private var shouldSynchronize = true
    
    private let defaultMonthTitleColor = UIColor.label
    private let defaultNavigationElementsColor = UIColor.tertiaryLabel
    private let defaultWeekCaptionsColor = UIColor.secondaryLabel
    private let defaultWorkingDayColor = UIColor.label
    private let defaultWeekendDayColor = UIColor(red: 0.63, green: 0, blue: 0, alpha: 1.0)
    private let defaultCurrentDayColor = UIColor(red: 0.20, green: 0.50, blue: 0, alpha: 1.0)
    private let defaultShortEventColor = UIColor(red: 0.30, green: 0.25, blue: 0.97, alpha: 1.0)
    private let defaultAlldayEventColor = UIColor(red: 0.63, green: 0, blue: 0, alpha: 1.0)
    private let defaultShouldDisplayWeekNumbers = true

    public init() {
        storage = UserDefaults(suiteName: "group.V8NCXSZ3T7.me.bronenos.minimonth") ?? .standard
    }

    public var monthTitleColorLight: UIColor {
        get { getColor(for: #function) ?? defaultMonthTitleColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var monthTitleColorDark: UIColor {
        get { getColor(for: #function) ?? defaultMonthTitleColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorLight: UIColor {
        get { getColor(for: #function) ?? defaultNavigationElementsColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorDark: UIColor {
        get { getColor(for: #function) ?? defaultNavigationElementsColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorLight: UIColor {
        get { getColor(for: #function) ?? defaultWeekCaptionsColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorDark: UIColor {
        get { getColor(for: #function) ?? defaultWeekCaptionsColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorLight: UIColor {
        get { getColor(for: #function) ?? defaultWorkingDayColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorDark: UIColor {
        get { getColor(for: #function) ?? defaultWorkingDayColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorLight: UIColor {
        get { getColor(for: #function) ?? defaultWeekendDayColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorDark: UIColor {
        get { getColor(for: #function) ?? defaultWeekendDayColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorLight: UIColor {
        get { getColor(for: #function) ?? defaultCurrentDayColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorDark: UIColor {
        get { getColor(for: #function) ?? defaultCurrentDayColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorLight: UIColor {
        get { getColor(for: #function) ?? defaultShortEventColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorDark: UIColor {
        get { getColor(for: #function) ?? defaultShortEventColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorLight: UIColor {
        get { getColor(for: #function) ?? defaultAlldayEventColor.light }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorDark: UIColor {
        get { getColor(for: #function) ?? defaultAlldayEventColor.dark }
        set { setColor(newValue, for: #function) }
    }
    
    public var shouldDisplayWeekNumbers: Bool {
        get { getBool(for: #function) ?? defaultShouldDisplayWeekNumbers }
        set { setBool(newValue, for: #function) }
    }
    
    public func resetColors() {
        shouldSynchronize = false
        defer {
            shouldSynchronize = true
            synchronizeIfNeeded()
        }
        
        monthTitleColorLight = defaultMonthTitleColor.light
        monthTitleColorDark = defaultMonthTitleColor.dark
        navigationElementsColorLight = defaultNavigationElementsColor.light
        navigationElementsColorDark = defaultNavigationElementsColor.dark
        weekCaptionsColorLight = defaultWeekCaptionsColor.light
        weekCaptionsColorDark = defaultWeekCaptionsColor.dark
        workingDayColorLight = defaultWorkingDayColor.light
        workingDayColorDark = defaultWorkingDayColor.dark
        weekendDayColorLight = defaultWeekendDayColor.light
        weekendDayColorDark = defaultWeekendDayColor.dark
        currentDayColorLight = defaultCurrentDayColor.light
        currentDayColorDark = defaultCurrentDayColor.dark
        shortEventColorLight = defaultShortEventColor.light
        shortEventColorDark = defaultShortEventColor.dark
        alldayEventColorLight = defaultAlldayEventColor.light
        alldayEventColorDark = defaultAlldayEventColor.dark
    }
    
    private func getColor(for key: String) -> UIColor? {
        if let rgb = storage.object(forKey: key) as? [CGFloat] {
            return UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: rgb[3])
        }
        else {
            return nil
        }
    }
    
    private func setColor(_ value: UIColor?, for key: String) {
        if let components = value?.cgColor.components {
            switch components {
            case let rgba where rgba.count == 4: storage.set(rgba, forKey: key)
            case let rgb where rgb.count == 3: storage.set(rgb + [1.0], forKey: key)
            case let wa where wa.count == 2: storage.set([CGFloat](repeating: wa[0], count: 3) + [wa[1]], forKey: key)
            default: storage.set([CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(1.0)], forKey: key)
            }
        }
        else {
            storage.removeObject(forKey: key)
        }
        
        synchronizeIfNeeded()
    }
    
    private func getBool(for key: String) -> Bool? {
        if let _ = storage.value(forKey: key) {
            return storage.bool(forKey: key)
        }
        else {
            return nil
        }
    }
    
    private func setBool(_ value: Bool, for key: String) {
        storage.set(value, forKey: key)
        synchronizeIfNeeded()
    }
    
    private func synchronizeIfNeeded() {
        guard shouldSynchronize else { return }
        storage.synchronize()
        objectWillChange.send()
    }
}

fileprivate extension UIColor {
    var light: UIColor {
        return resolvedFor(style: .light)
    }
    
    var dark: UIColor {
        return resolvedFor(style: .dark)
    }
    
    private func resolvedFor(style: UIUserInterfaceStyle) -> UIColor {
        let traitCollection = UITraitCollection(userInterfaceStyle: style)
        return resolvedColor(with: traitCollection)
    }
}
