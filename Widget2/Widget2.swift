//
//  Widget2.swift
//  Widget2
//
//  Created by Stan Potemkin on 23.06.2020.
//  Copyright © 2020 bronenos. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    public func snapshot(with context: Context, completion: @escaping (MiniMonthTimelineEntry) -> ()) {
        let entry = MiniMonthTimelineEntry(date: Date())
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let numberOfDays = Calendar.current.shortWeekdaySymbols.count
        let entries: [MiniMonthTimelineEntry] = (0 ..< numberOfDays).compactMap { dayOffset in
            let nextDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)
            return nextDate.flatMap(MiniMonthTimelineEntry.init)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MiniMonthTimelineEntry: TimelineEntry {
    public let date: Date
}

struct PlaceholderView : View {
    var body: some View {
        let preferencesDriver = PreferencesDriver()
        let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: WidgetTraits())
        
        let rootInteractor = CalendarInteractor(style: .month)
        let backgroundColor = designBook.cached(usage: .backgroundColor)
        return CalendarView(interactor: rootInteractor, position: .fill, backgroundColor: backgroundColor)
            .environmentObject(preferencesDriver)
            .environmentObject(designBook)
    }
}

final class WidgetTraits: NSObject, UITraitEnvironment {
    let traitCollection = UITraitCollection(userInterfaceStyle: .dark)
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { }
}

@main
struct Widget2: Widget {
    public var body: some WidgetConfiguration {
        let kind = "me.bronenos.Widget2"
        let provider = Provider()
        let placeholder = PlaceholderView()
        return StaticConfiguration(kind: kind, provider: provider, placeholder: placeholder, content: { _ in placeholder })
            .configurationDisplayName("MiniMonth")
            .description("Shows the compact Calendar glance")
            .supportedFamilies([.systemMedium])
    }
}
