//
//  DesignBook.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

public final class DesignBook: ObservableObject {
    public var objectWillChange = ObservableObjectPublisher()
    
    let preferencesDriver: PreferencesDriver
    let traitEnvironment: UITraitEnvironment
    
    private var cachedUsages = [DesignBookColorUsage: Color]()
    
    public init(preferencesDriver: PreferencesDriver, traitEnvironment: UITraitEnvironment) {
        self.preferencesDriver = preferencesDriver
        self.traitEnvironment = traitEnvironment
    }
    
    public var horizontalSizeClass: UserInterfaceSizeClass {
        switch traitEnvironment.traitCollection.horizontalSizeClass {
        case .compact:
            print("horizontalSizeClass[compact]")
            return .compact
            
        case .regular:
            print("horizontalSizeClass[regular]")
            return .regular
            
        case .unspecified:
            print("horizontalSizeClass[unspecified]")
            return .compact
            
        @unknown default:
            print("horizontalSizeClass[default]")
            return .compact
        }
    }
    
    public let layout = DesignBookLayout(
        weekHeaderHeight: 27,
        weekNumberWidthCoef: 0.15,
        weekDayHeight: 27,
        eventMarkerSide: 4
    )
    
    public func color(usage: DesignBookColorUsage) -> UIColor {
        return color(.usage(usage))
    }
    
    public func cached(usage: DesignBookColorUsage) -> Color {
        if let value = cachedUsages[usage] {
            return value
        }
        
        let value = Color(self.color(usage: usage))
        cachedUsages[usage] = value
        
        return value
    }
    
    public func resolve(dynamicColor: UIColor) -> UIColor {
        return dynamicColor.resolvedColor(with: traitEnvironment.traitCollection)
    }
    
    public func font(weight: DesignBookFontWeight, category: UIFont.TextStyle, defaultSizes: DesignBookFontSize, maximumSizes: DesignBookFontSize?) -> UIFont {
        let defaultSize = extractFontSize(defaultSizes)
        let defaultFont = UIFont.systemFont(ofSize: defaultSize, weight: adjustedFontWeight(weight))
        let maximumSize = maximumSizes.flatMap(extractFontSize) ?? .infinity
        return UIFontMetrics(forTextStyle: category).scaledFont(for: defaultFont, maximumPointSize: maximumSize)
    }
    
    public func discardCache() {
        cachedUsages.removeAll()
        objectWillChange.send()
    }
    
    private func color(_ color: DesignBookColor) -> UIColor {
        switch color {
        case .native(let value): return value
        case .hex(let hex): return obtainColor(byHex: hex)
        case .usage(let usage): return obtainColor(forUsage: usage)
        case .pref(let keyPath): return obtainColor(byPref: keyPath)
        }
    }
    
    private func obtainColor(byHex hex: Int) -> UIColor {
        return UIColor(hex: hex)
    }
    
    private func obtainColor(byPref keyPath: PreferencesReadableKeyPath) -> UIColor {
        return preferencesDriver[keyPath: keyPath]
    }
    
    private func obtainColor(forUsage usage: DesignBookColorUsage) -> UIColor {
        switch usage {
        // global
        case .white: return UIColor.white
        case .black: return UIColor.black
        // foregrounds
        case .primaryForeground: return combine(light: .native(.black), dark: .native(.white))
        // preferences
        case .monthColor: return combine(light: .pref(\.monthColorLight), dark: .pref(\.monthColorDark))
        case .navigationColor: return combine(light: .pref(\.navigationColorLight), dark: .pref(\.navigationColorDark))
        case .captionColor: return combine(light: .pref(\.captionColorLight), dark: .pref(\.captionColorDark))
        case .workdayColor: return combine(light: .pref(\.workdayColorLight), dark: .pref(\.workdayColorDark))
        case .weekendColor: return combine(light: .pref(\.weekendColorLight), dark: .pref(\.weekendColorDark))
        case .holidayColor: return combine(light: .pref(\.holidayColorLight), dark: .pref(\.holidayColorDark))
        case .todayColor: return combine(light: .pref(\.todayColorLight), dark: .pref(\.todayColorDark))
        case .eventColor: return combine(light: .pref(\.eventColorLight), dark: .pref(\.eventColorDark))
        }
    }
    
    private func adjustedFontWeight(_ weight: DesignBookFontWeight) -> UIFont.Weight {
        if UIAccessibility.isBoldTextEnabled {
            switch weight {
            case .light: return .regular
            case .regular: return .medium
            case .medium: return .semibold
            case .semibold: return .bold
            case .bold: return .heavy
            case .heavy: return .black
            }
        }
        else {
            switch weight {
            case .light: return .light
            case .regular: return .regular;
            case .medium: return .medium;
            case .semibold: return .semibold;
            case .bold: return .bold
            case .heavy: return .heavy
            }
        }
    }
    
    private func extractFontSize(_ value: DesignBookFontSize) -> CGFloat {
        switch traitEnvironment.traitCollection.horizontalSizeClass {
        case .compact: return value.compact
        case .regular: return value.regular
        case .unspecified: return value.compact
        @unknown default: return value.compact
        }
    }
    
    private func combine(light lightColor: DesignBookColor, dark darkColor: DesignBookColor) -> UIColor {
        return UIColor { [unowned self] traits in
            switch traits.userInterfaceStyle {
            case .light: return self.color(lightColor)
            case .dark: return self.color(darkColor)
            case .unspecified: return self.color(lightColor)
            @unknown default: return self.color(lightColor)
            }
        }
    }
}

fileprivate extension UIColor {
    @objc(initWithHexCode:) convenience init(hex: Int) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat((hex & 0x0000FF) >> 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    @objc(initWithHexString:) convenience init(hex: String) {
        if let code = Int(hex, radix: 16) {
            self.init(hex: code)
        }
        else {
            self.init(white: 0, alpha: 1.0)
        }
    }
    
    func withAlpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
}
