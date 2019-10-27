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
            ForEach(obtainGrid(), id: \.self) { row in
                HosterColorsRow(firstMeta: row[0], secondMeta: row[1])
            }
        }
    }
    
    private func obtainGrid() -> [[HosterColorMeta]] {
        let metas: [HosterColorMeta]
        switch colorScheme {
        case .light: metas = dynamicMetas.map { HosterColorMeta(caption: $0.caption, keyPath: $0.lightKeyPath) }
        case .dark: metas = dynamicMetas.map { HosterColorMeta(caption: $0.caption, keyPath: $0.darkKeyPath) }
        @unknown default: metas = dynamicMetas.map { HosterColorMeta(caption: $0.caption, keyPath: $0.lightKeyPath) }
        }
        
        var grid = [[HosterColorMeta]]()
        _ = metas.publisher.collect(2).collect().sink(receiveValue: { value in grid = value })
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
