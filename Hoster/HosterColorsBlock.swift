//
//  HosterColorsBlock.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

struct HosterColorMeta: Hashable {
    let caption: String
    let keyPath: KeyPath<PreferencesDriver, UIColor>
}

struct HosterColorsBlock: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    
    private let metas: [HosterColorMeta] = [
        HosterColorMeta(caption: "Month", keyPath: \.monthColorLight),
        HosterColorMeta(caption: "Arrows", keyPath: \.navigationColorLight),
        HosterColorMeta(caption: "Axis", keyPath: \.captionColorLight),
        HosterColorMeta(caption: "Workdays", keyPath: \.workdayColorLight),
        HosterColorMeta(caption: "Weekend", keyPath: \.weekendColorLight),
        HosterColorMeta(caption: "Holidays", keyPath: \.holidayColorLight),
        HosterColorMeta(caption: "Today", keyPath: \.todayColorLight),
        HosterColorMeta(caption: "Events", keyPath: \.eventColorLight)
    ]

    var body: some View {
        VStack {
            ForEach(obtainGrid(), id: \.self) { row in
                HosterColorsRow(firstMeta: row[0], secondMeta: row[1])
            }
        }
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
    }
    
    private func obtainGrid() -> [[HosterColorMeta]] {
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
                color: preferencesDriver[keyPath: firstMeta.keyPath])
            
            HosterColorControl(
                caption: secondMeta.caption,
                color: preferencesDriver[keyPath: secondMeta.keyPath])
        }
    }
}
