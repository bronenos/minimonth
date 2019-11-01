//
//  HosterColorsBlock.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct HosterColorDynamicMeta: Hashable {
    let captionKey: String
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

    private let dynamicMetas: [HosterColorDynamicMeta] = [
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Month", lightKeyPath: \.monthColorLight, darkKeyPath: \.monthColorDark),
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Arrows", lightKeyPath: \.navigationColorLight, darkKeyPath: \.navigationColorDark),
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Axis", lightKeyPath: \.captionColorLight, darkKeyPath: \.captionColorDark),
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Workday", lightKeyPath: \.workdayColorLight, darkKeyPath: \.workdayColorDark),
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Weekend", lightKeyPath: \.weekendColorLight, darkKeyPath: \.weekendColorDark),
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Holiday", lightKeyPath: \.holidayColorLight, darkKeyPath: \.holidayColorDark),
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Today", lightKeyPath: \.todayColorLight, darkKeyPath: \.todayColorDark),
        HosterColorDynamicMeta(captionKey: "Preferences.Colors.Event", lightKeyPath: \.eventColorLight, darkKeyPath: \.eventColorDark)
    ]

    var body: some View {
        VStack {
//            if UIScreen.main.kind.atLeast(.extraLarge) {
//                ForEach(self.obtainGrid(), id: \.self) { row in
//                    HosterColorsRow(firstMeta: row[0], secondMeta: row[1])
//                }
//            }
//            else {
                ForEach(self.obtainList(), id: \.self) { meta in
                    HosterColorControl(caption: meta.caption, keyPath: meta.keyPath)
                }
//            }
        }
    }
    
    private func obtainList() -> [HosterColorMeta] {
        switch colorScheme {
        case .light: return dynamicMetas.map { HosterColorMeta(caption: $0.captionKey, keyPath: $0.lightKeyPath) }
        case .dark: return dynamicMetas.map { HosterColorMeta(caption: $0.captionKey, keyPath: $0.darkKeyPath) }
        @unknown default: return dynamicMetas.map { HosterColorMeta(caption: $0.captionKey, keyPath: $0.lightKeyPath) }
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
