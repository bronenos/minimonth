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
    var monthTitleColorLight: UIColor! { get set }
    var monthTitleColorDark: UIColor! { get set }
    var navigationElementsColorLight: UIColor! { get set }
    var navigationElementsColorDark: UIColor! { get set }
    var weekCaptionsColorLight: UIColor! { get set }
    var weekCaptionsColorDark: UIColor! { get set }
    var workingDayColorLight: UIColor! { get set }
    var workingDayColorDark: UIColor! { get set }
    var weekendDayColorLight: UIColor! { get set }
    var weekendDayColorDark: UIColor! { get set }
    var currentDayColorLight: UIColor! { get set }
    var currentDayColorDark: UIColor! { get set }
    var currentDayTextColorLight: UIColor! { get set }
    var currentDayTextColorDark: UIColor! { get set }
    var shortEventColorLight: UIColor! { get set }
    var shortEventColorDark: UIColor! { get set }
    var alldayEventColorLight: UIColor! { get set }
    var alldayEventColorDark: UIColor! { get set }
    var shouldDisplayWeekNumbers: Bool! { get set }
    func resetColors()
}

public final class PreferencesDriver: IPreferencesDriver, ObservableObject {
    public var objectWillChange = ObservableObjectPublisher()
    
    private let storage: UserDefaults
    private var shouldSynchronize = true
    
    public init() {
        storage = UserDefaults(suiteName: "group.V8NCXSZ3T7.me.bronenos.minimonth") ?? .standard
    }

    public var monthTitleColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var monthTitleColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.235, green: 0.235, blue: 0.262, alpha: 0.380) }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.921, green: 0.921, blue: 0.960, alpha: 0.38) }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.235, green: 0.235, blue: 0.262, alpha: 0.68) }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.921, green: 0.921, blue: 0.960, alpha: 0.68) }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.610, green: 0.070, blue: 0.070, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.880, green: 0.400, blue: 0.350, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.200, green: 0.450, blue: 0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.200, green: 0.450, blue: 0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayTextColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayTextColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.300, green: 0.250, blue: 0.970, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.370, green: 0.490, blue: 0.980, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.610, green: 0.070, blue: 0.070, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.880, green: 0.400, blue: 0.350, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var shouldDisplayWeekNumbers: Bool! {
        get { getBool(for: #function) ?? true }
        set { setBool(newValue, for: #function) }
    }
    
    public func resetColors() {
        shouldSynchronize = false
        defer {
            shouldSynchronize = true
            synchronizeIfNeeded()
        }
        
        monthTitleColorLight = nil
        monthTitleColorDark = nil
        navigationElementsColorLight = nil
        navigationElementsColorDark = nil
        weekCaptionsColorLight = nil
        weekCaptionsColorDark = nil
        workingDayColorLight = nil
        workingDayColorDark = nil
        weekendDayColorLight = nil
        weekendDayColorDark = nil
        currentDayColorLight = nil
        currentDayColorDark = nil
        currentDayTextColorLight = nil
        currentDayTextColorDark = nil
        shortEventColorLight = nil
        shortEventColorDark = nil
        alldayEventColorLight = nil
        alldayEventColorDark = nil
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
        if let components = value?.extract() {
            storage.set(components, forKey: key)
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
    
    private func setBool(_ value: Bool?, for key: String) {
        if let value = value {
            storage.set(value, forKey: key)
        }
        else {
            storage.removeObject(forKey: key)
        }
        
        synchronizeIfNeeded()
    }
    
    private func synchronizeIfNeeded() {
        guard shouldSynchronize else { return }
        storage.synchronize()
        objectWillChange.send()
    }
}

extension UIColor {
    var light: UIColor {
        return resolvedFor(style: .light)
    }
    
    var dark: UIColor {
        return resolvedFor(style: .dark)
    }
    
    func extract() -> [CGFloat]? {
        if let components = cgColor.components {
            switch components {
            case let rgba where rgba.count == 4: return rgba
            case let rgb where rgb.count == 3: return rgb + [1.0]
            case let wa where wa.count == 2: return [CGFloat](repeating: wa[0], count: 3) + [wa[1]]
            default: return [0, 0, 0, 1.0]
            }
        }
        else {
            return [0, 0, 0, 1.0]
        }
    }
    
    func resolvedFor(style: UIUserInterfaceStyle) -> UIColor {
        let traitCollection = UITraitCollection(userInterfaceStyle: style)
        return resolvedColor(with: traitCollection)
    }
    
    func mixWithBaseColor(_ baseColor: UIColor) -> UIColor {
        guard let base = baseColor.extract() else { return self }
        guard let components = extract() else { return self }
        
        let r = base[0] * (1.0 - components[3]) + components[0] * components[3];
        let g = base[1] * (1.0 - components[3]) + components[1] * components[3];
        let b = base[2] * (1.0 - components[3]) + components[2] * components[3];
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
