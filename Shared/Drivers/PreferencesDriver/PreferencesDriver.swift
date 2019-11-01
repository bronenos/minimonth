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
    private let defaultWeekendDayColor = UIColor.systemRed
    private let defaultCurrentDayColor = UIColor.systemGreen
    private let defaultShortEventColor = UIColor.systemBlue
    private let defaultAlldayEventColor = UIColor.systemOrange
    private let defaultShouldDisplayWeekNumbers = true

    public init() {
        storage = UserDefaults(suiteName: "group.V8NCXSZ3T7.me.bronenos.minimonth") ?? .standard
    }

    public var monthTitleColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var monthTitleColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.tertiaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.tertiaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.secondaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.secondaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.systemRed }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.systemRed }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.systemGreen }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.systemGreen }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.systemBlue }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.systemBlue }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorLight: UIColor {
        get { getColor(for: #function) ?? UIColor.systemOrange }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorDark: UIColor {
        get { getColor(for: #function) ?? UIColor.systemOrange }
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
        
        let lightTraitCollection = UITraitCollection(userInterfaceStyle: .light)
        let darkTraitCollection = UITraitCollection(userInterfaceStyle: .dark)

        monthTitleColorLight = defaultMonthTitleColor.resolvedColor(with: lightTraitCollection)
        monthTitleColorDark = defaultMonthTitleColor.resolvedColor(with: darkTraitCollection)
        navigationElementsColorLight = defaultNavigationElementsColor.resolvedColor(with: lightTraitCollection)
        navigationElementsColorDark = defaultNavigationElementsColor.resolvedColor(with: darkTraitCollection)
        weekCaptionsColorLight = defaultWeekCaptionsColor.resolvedColor(with: lightTraitCollection)
        weekCaptionsColorDark = defaultWeekCaptionsColor.resolvedColor(with: darkTraitCollection)
        workingDayColorLight = defaultWorkingDayColor.resolvedColor(with: lightTraitCollection)
        workingDayColorDark = defaultWorkingDayColor.resolvedColor(with: darkTraitCollection)
        weekendDayColorLight = defaultWeekendDayColor.resolvedColor(with: lightTraitCollection)
        weekendDayColorDark = defaultWeekendDayColor.resolvedColor(with: darkTraitCollection)
        currentDayColorLight = defaultCurrentDayColor.resolvedColor(with: lightTraitCollection)
        currentDayColorDark = defaultCurrentDayColor.resolvedColor(with: darkTraitCollection)
        shortEventColorLight = defaultShortEventColor.resolvedColor(with: lightTraitCollection)
        shortEventColorDark = defaultShortEventColor.resolvedColor(with: darkTraitCollection)
        alldayEventColorLight = defaultAlldayEventColor.resolvedColor(with: lightTraitCollection)
        alldayEventColorDark = defaultAlldayEventColor.resolvedColor(with: darkTraitCollection)
    }
    
    private func getColor(for key: String) -> UIColor? {
        if let rgb = storage.object(forKey: key) as? [CGFloat] {
            return UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1.0)
        }
        else {
            return nil
        }
    }
    
    private func setColor(_ value: UIColor?, for key: String) {
        if let value = value {
            var rgb = [CGFloat](repeating: 0, count: 3)
            rgb.withUnsafeMutableBufferPointer { pointer in
                let r = pointer.baseAddress?.advanced(by: 0)
                let g = pointer.baseAddress?.advanced(by: 1)
                let b = pointer.baseAddress?.advanced(by: 2)
                value.getRed(r, green: g, blue: b, alpha: nil)
            }
            
            storage.set(rgb, forKey: key)
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
