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
    let traitEnvironment: UITraitEnvironment?
    
    private var cachedUsages = [DesignBookColorUsage: Color]()
    
    public init(preferencesDriver: PreferencesDriver, traitEnvironment: UITraitEnvironment?) {
        self.preferencesDriver = preferencesDriver
        self.traitEnvironment = traitEnvironment
    }
    
    public var horizontalSizeClass: UserInterfaceSizeClass {
        switch traitEnvironment?.traitCollection.horizontalSizeClass {
        case .compact: return .compact
        case .regular: return .regular
        case .unspecified: return .compact
        case nil: return .compact
        @unknown default: return .compact
        }
    }
    
    public func adjustments(position: CalendarPosition, size: CGSize) -> DesignBookAdjustments {
        let sizeLarge = (size.height == 0 || size.height > 150)
        
        let topSpacer: AnyView = convert(position) { value in
            switch value {
            case .host: return AnyView(Spacer().frame(idealHeight: 0, maxHeight: .infinity, alignment: .top))
            case .today: return AnyView(Spacer().frame(idealHeight: 0, maxHeight: 0, alignment: .top))
            case .small: return AnyView(Spacer().frame(idealHeight: 7, maxHeight: 7))
            case .medium: return AnyView(Spacer().frame(idealHeight: 7, maxHeight: 7))
            }
        }
        
        let headerMargins: EdgeInsets = convert(position) { value in
            switch value {
            case .host: return EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            case .today: return EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            case .small where sizeLarge: return EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6)
            case .medium where sizeLarge: return EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6)
            case .small: return EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            case .medium: return EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
            }
        }
        
        let captionHeight: CGFloat = convert(position) { value in
            switch value {
            case .host: return 27
            case .today: return 27
            case .small: return 16
            case .medium: return 16
            }
        }
        
        let rowHeight: CGFloat = convert(position) { value in
            switch value {
            case .host: return 27
            case .today: return 27
            case .small: return (size.height - 60) / 6
            case .medium: return (size.height - 60) / 6
            }
        }
        
        let eventMarkerSide: CGFloat = convert(position) { value in
            switch value {
            case .host: return 4
            case .today: return 4
            case .small: return 2
            case .medium: return 4
            }
        }
        
        let dynamicVerticalAlignment: Bool = convert(position) { value in
            switch value {
            case .host: return false
            case .today: return false
            case .small: return true
            case .medium: return true
            }
        }
        
        let displayNavigationControls: Bool = convert(position) { value in
            switch value {
            case .host: return true
            case .today: return true
            case .small: return false
            case .medium: return false
            }
        }

        let displayEventAtBottom: Bool = convert(position) { value in
            switch value {
            case .host: return true
            case .today: return true
            case .small: return true
            case .medium: return false
            }
        }
        
        let displayAllWeekNumbers: Bool = convert(position) { value in
            switch value {
            case .host: return true
            case .today: return true
            case .small: return false
            case .medium: return true
            }
        }

        let horizontalMargins: CGFloat = convert(position) { value in
            switch value {
            case .host: return 10
            case .today: return 10
            case .small: return 5
            case .medium: return 10
            }
        }
        
        let weekdayFont: Font = convert(position) { value in
            switch value {
            case .host: return .system(size: 11, weight: .semibold)
            case .today: return .system(size: 11, weight: .semibold)
            case .small where sizeLarge: return .system(size: 10, weight: .semibold)
            case .small: return .system(size: 9, weight: .semibold)
            case .medium where sizeLarge: return .system(size: 12, weight: .semibold)
            case .medium: return .system(size: 10, weight: .semibold)
            }
        }
        
        let weekCaptionKind: DesignWeekCaptionKind = convert(position) { value in
            switch value {
            case .host: return .medium
            case .today: return .medium
            case .small: return .short
            case .medium: return .medium
            }
        }
        
        return DesignBookAdjustments(
            topSpacer: topSpacer,
            headerMargins: headerMargins,
            captionHeight: captionHeight,
            rowHeight: rowHeight,
            eventMarkerSide: eventMarkerSide,
            dynamicVerticalAlignment: dynamicVerticalAlignment,
            displayNavigationControls: displayNavigationControls,
            displayEventAtBottom: displayEventAtBottom,
            displayAllWeekNumbers: displayAllWeekNumbers,
            horizontalMargins: horizontalMargins,
            weekdayFont: weekdayFont,
            weekCaptionKind: weekCaptionKind)
    }
        
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
        guard let env = traitEnvironment else { return dynamicColor }
        return dynamicColor.resolvedColor(with: env.traitCollection)
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
        case .white: return UIColor.clear
        case .black: return UIColor.black
        // foregrounds
        case .primaryForeground: return combine(light: .native(.black), dark: .native(.white))
        // preferences
        case .monthColor: return combine(light: .pref(\.monthTitleColorLight), dark: .pref(\.monthTitleColorDark))
        case .navigationColor: return combine(light: .pref(\.navigationElementsColorLight), dark: .pref(\.navigationElementsColorDark))
        case .captionColor: return combine(light: .pref(\.weekCaptionsColorLight), dark: .pref(\.weekCaptionsColorDark))
        case .workdayColor: return combine(light: .pref(\.workingDayColorLight), dark: .pref(\.workingDayColorDark))
        case .weekendColor: return combine(light: .pref(\.weekendDayColorLight), dark: .pref(\.weekendDayColorDark))
        case .holidayColor: return combine(light: .pref(\.alldayEventColorLight), dark: .pref(\.alldayEventColorDark))
        case .todayColor: return combine(light: .pref(\.currentDayColorLight), dark: .pref(\.currentDayColorDark))
        case .todayTextColor: return combine(light: .pref(\.currentDayTextColorLight), dark: .pref(\.currentDayTextColorDark))
        case .eventColor: return combine(light: .pref(\.shortEventColorLight), dark: .pref(\.shortEventColorDark))
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
        switch traitEnvironment?.traitCollection.horizontalSizeClass {
        case .compact: return value.compact
        case .regular: return value.regular
        case .unspecified: return value.compact
        case nil: return value.compact
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
    convenience init(hex: Int) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat((hex & 0x0000FF) >> 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    convenience init(hex: String) {
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
