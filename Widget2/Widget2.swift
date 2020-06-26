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
        let entry = MiniMonthTimelineEntry(date: Date(), family: context.family)
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let numberOfDays = Calendar.current.shortWeekdaySymbols.count
        let entries: [MiniMonthTimelineEntry] = (0 ..< numberOfDays).compactMap { dayOffset in
            let nextDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)
            return nextDate.flatMap { date in MiniMonthTimelineEntry(date: date, family: context.family) }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MiniMonthTimelineEntry: TimelineEntry {
    public let date: Date
    public let family: WidgetFamily
}

struct PlaceholderView : View {
    var body: some View {
        return Image("paper")
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
        return StaticConfiguration(
            kind: kind,
            provider: provider,
            placeholder: placeholder,
            content: { entry in generateCalendar(entry: entry, traitEnv: nil) })
            .configurationDisplayName("MiniMonth")
            .description("Shows the compact Calendar glance")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}

fileprivate func generateCalendar(entry: MiniMonthTimelineEntry, traitEnv: UITraitEnvironment?) -> some View {
    let position: CalendarPosition = convert(entry.family) { value in
        switch value {
        case .systemSmall: return .small
        case .systemMedium: return .medium
        case .systemLarge: return .medium
        @unknown default: return .medium
        }
    }
    
    let preferencesDriver = PreferencesDriver()
    let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: traitEnv ?? WidgetTraits())
    
    let rootInteractor = CalendarInteractor(style: .month, shortest: position.shouldDisplayShortestCaptions)
    let background = Image("paper").resizable(resizingMode: .stretch)
    
    return CalendarView(interactor: rootInteractor, position: position, background: background)
        .environmentObject(preferencesDriver)
        .environmentObject(designBook)
}
