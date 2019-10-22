//
//  DesignBook.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit
import SwiftUI

final class DesignBook: ObservableObject {
    var traitProvider: (() -> UITraitEnvironment)?
    
    let layout = DesignBookLayout(
        weekNumberWidthCoef: 0.1,
        weekDayRatio: 0.7
    )
    
    func color(_ color: DesignBookColor, style: DesignBookStyle = .light) -> UIColor {
        switch color {
        case .native(let value): return value
        case .hex(let hex): return obtainColor(byHex: hex)
        case .usage(let usage): return obtainColor(forUsage: usage)
        }
    }
    
    func color(hex: Int) -> UIColor {
        return color(.hex(hex))
    }
    
    func color(usage: DesignBookColorUsage) -> UIColor {
        return color(.usage(usage))
    }
    
    func font(weight: DesignBookFontWeight, category: UIFont.TextStyle, defaultSizes: DesignBookFontSize, maximumSizes: DesignBookFontSize?) -> UIFont {
        let defaultSize = extractFontSize(defaultSizes)
        let defaultFont = UIFont.systemFont(ofSize: defaultSize, weight: adjustedFontWeight(weight))
        let maximumSize = maximumSizes.flatMap(extractFontSize) ?? .infinity
        return UIFontMetrics(forTextStyle: category).scaledFont(for: defaultFont, maximumPointSize: maximumSize)
    }
    
    private func obtainColor(byHex hex: Int) -> UIColor {
        return UIColor(hex: hex)
    }
    
    private func obtainColor(forUsage usage: DesignBookColorUsage) -> UIColor {
        switch usage {
        // global
        case .white: return UIColor.white
        case .black: return UIColor.black
        // foregrounds
        case .primaryForeground: return dynamicColor(light: .native(.black), dark: .native(.white))
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
        switch traitProvider?().traitCollection.horizontalSizeClass ?? .compact {
        case .compact: return value.compact
        case .regular: return value.regular
        case .unspecified: return value.compact
        @unknown default: return value.compact
        }
    }
    
    private func dynamicColor(light lightColor: DesignBookColor, dark darkColor: DesignBookColor) -> UIColor {
        return UIColor { [unowned self] traits in
            let style = traits.userInterfaceStyle.toDesignStyle
            switch style {
            case .light: return self.color(lightColor, style: style)
            case .dark: return self.color(darkColor, style: style)
            }
        }
    }
}

fileprivate extension UIUserInterfaceStyle {
    var toDesignStyle: DesignBookStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .unspecified: return .light
        @unknown default: return .light
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
