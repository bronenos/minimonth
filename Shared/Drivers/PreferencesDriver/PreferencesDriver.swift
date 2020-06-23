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
    var backgroundColorLight: UIColor! { get set }
    var backgroundColorDark: UIColor! { get set }
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

    public var backgroundColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor.lightGray }
        set { setColor(newValue, for: #function) }
    }
    
    public var backgroundColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor.darkGray }
        set { setColor(newValue, for: #function) }
    }
    
    public var monthTitleColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var monthTitleColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor.tertiaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var navigationElementsColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor.tertiaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor.secondaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekCaptionsColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor.secondaryLabel }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var workingDayColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor.label }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.61, green: 0.07, blue: 0.07, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var weekendDayColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.88, green: 0.40, blue: 0.35, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.20, green: 0.45, blue: 0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var currentDayColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.20, green: 0.45, blue: 0, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.30, green: 0.25, blue: 0.97, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var shortEventColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.37, green: 0.49, blue: 0.98, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorLight: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.61, green: 0.07, blue: 0.07, alpha: 1.0) }
        set { setColor(newValue, for: #function) }
    }
    
    public var alldayEventColorDark: UIColor! {
        get { getColor(for: #function) ?? UIColor(red: 0.88, green: 0.40, blue: 0.35, alpha: 1.0) }
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
        
        backgroundColorLight = nil
        backgroundColorDark = nil
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
