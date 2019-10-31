//
//  HosterColorsBlock.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

struct HosterColorDynamicMeta: Hashable {
    let caption: String
    let lightKeyPath: PreferencesWritableKeyPath
    let darkKeyPath: PreferencesWritableKeyPath
}

struct HosterColorMeta: Hashable {
    let caption: String
    let keyPath: PreferencesWritableKeyPath
}

struct HosterColorsBlock: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    @Environment(\.colorScheme) private var colorScheme
    @State var dynamicWidth = UIScreen.main.bounds.width

    private let dynamicMetas: [HosterColorDynamicMeta] = [
        HosterColorDynamicMeta(caption: "Month", lightKeyPath: \.monthColorLight, darkKeyPath: \.monthColorDark),
        HosterColorDynamicMeta(caption: "Arrows", lightKeyPath: \.navigationColorLight, darkKeyPath: \.navigationColorDark),
        HosterColorDynamicMeta(caption: "Axis", lightKeyPath: \.captionColorLight, darkKeyPath: \.captionColorDark),
        HosterColorDynamicMeta(caption: "Workdays", lightKeyPath: \.workdayColorLight, darkKeyPath: \.workdayColorDark),
        HosterColorDynamicMeta(caption: "Weekend", lightKeyPath: \.weekendColorLight, darkKeyPath: \.weekendColorDark),
        HosterColorDynamicMeta(caption: "Holidays", lightKeyPath: \.holidayColorLight, darkKeyPath: \.holidayColorDark),
        HosterColorDynamicMeta(caption: "Today", lightKeyPath: \.todayColorLight, darkKeyPath: \.todayColorDark),
        HosterColorDynamicMeta(caption: "Events", lightKeyPath: \.eventColorLight, darkKeyPath: \.eventColorDark)
    ]

    var body: some View {
        VStack {
            if dynamicWidth > 320 {
                ForEach(self.obtainGrid(), id: \.self) { row in
                    HosterColorsRow(firstMeta: row[0], secondMeta: row[1])
                }
            }
            else {
                ForEach(self.obtainList(), id: \.self) { meta in
                    HosterColorControl(caption: meta.caption, keyPath: meta.keyPath)
                }
            }
            
            HStack {
                Spacer().background(WidthPreferenceApply())
            }
        }
        .onPreferenceChange(WidthPreference.self) { width in
            DispatchQueue.main.async { self.dynamicWidth = width }
        }
    }
    
    private func obtainList() -> [HosterColorMeta] {
        switch colorScheme {
        case .light: return dynamicMetas.map { HosterColorMeta(caption: $0.caption, keyPath: $0.lightKeyPath) }
        case .dark: return dynamicMetas.map { HosterColorMeta(caption: $0.caption, keyPath: $0.darkKeyPath) }
        @unknown default: return dynamicMetas.map { HosterColorMeta(caption: $0.caption, keyPath: $0.lightKeyPath) }
        }
    }
    
    private func obtainGrid() -> [[HosterColorMeta]] {
        var grid = [[HosterColorMeta]]()
        _ = obtainList().publisher.collect(2).collect().sink(receiveValue: { value in grid = value })
        return grid
    }
}

struct HosterColorsRow: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    
    let firstMeta: HosterColorMeta
    let secondMeta: HosterColorMeta

    var body: some View {
        HStack(spacing: 0) {
            HosterColorControl(
                caption: firstMeta.caption,
                keyPath: firstMeta.keyPath)
                .padding(.trailing, 5)
            
            HosterColorControl(
                caption: secondMeta.caption,
                keyPath: secondMeta.keyPath)
                .padding(.leading, 5)
        }
    }
}

fileprivate struct WidthPreference: PreferenceKey {
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

fileprivate struct WidthPreferenceApply: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: WidthPreference.self, value: geometry.size.width)
        }
    }
}
