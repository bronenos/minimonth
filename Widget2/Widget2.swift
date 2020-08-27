//
//  Widget2.swift
//  Widget2
//
//  Created by Stan Potemkin on 23.06.2020.
//  Copyright © 2020 bronenos. All rights reserved.
//

import WidgetKit
import SwiftUI

struct MiniMonthTimelineEntry: TimelineEntry {
    public let date: Date
    public let family: WidgetFamily
    public let size: CGSize
    public let isPreview: Bool
}

struct WidgetTimelineProvider: TimelineProvider {
    public func snapshot(with context: Context, completion: @escaping (MiniMonthTimelineEntry) -> ()) {
        let entry = MiniMonthTimelineEntry(
            date: Date(),
            family: context.family,
            size: context.displaySize,
            isPreview: context.isPreview)
        
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let defaultInternal = TimeInterval(900)
        let defaultPoint = Date(timeIntervalSinceNow: defaultInternal)
        
        var nextPoints = [calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate) ?? defaultPoint]
        for quarterIndex in 0 ..< 4 {
            let point = calendar.date(byAdding: .second, value: Int(defaultInternal) * quarterIndex, to: currentDate) ?? defaultPoint
            nextPoints.append(point)
        }
        
        let nextPoint = nextPoints.min() ?? defaultPoint
        
        let entry = MiniMonthTimelineEntry(
            date: nextPoint,
            family: context.family,
            size: context.displaySize,
            isPreview: context.isPreview)
        
        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextPoint))
        
        completion(timeline)
    }
}

struct WidgetSmall: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "me.bronenos.widget-small",
            provider: WidgetTimelineProvider(),
//            placeholder: generateCalendar(
//                entry: MiniMonthTimelineEntry(
//                    date: Date(),
//                    family: .systemSmall,
//                    size: .zero,
//                    isPreview: true),
//                traitEnv: nil,
//                renderEvents: false),
            content: { entry in
                generateCalendar(
                    entry: entry,
                    traitEnv: nil,
                    renderEvents: !entry.isPreview)
            })
            .configurationDisplayName(LocalizedStringKey("widget_small_caption"))
            .description(LocalizedStringKey("widget_common_note"))
            .supportedFamilies([.systemSmall])
    }
}

struct WidgetMedium: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "me.bronenos.widget-medium",
            provider: WidgetTimelineProvider(),
//            placeholder: generateCalendar(
//                entry: MiniMonthTimelineEntry(
//                    date: Date(),
//                    family: .systemMedium,
//                    size: .zero,
//                    isPreview: true),
//                traitEnv: nil,
//                renderEvents: false),
            content: { entry in
                generateCalendar(
                    entry: entry,
                    traitEnv: nil,
                    renderEvents: !entry.isPreview)
            })
            .configurationDisplayName(LocalizedStringKey("widget_medium_caption"))
            .description(LocalizedStringKey("widget_common_note"))
            .supportedFamilies([.systemMedium])
    }
}

@main
struct WidgetPack: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WidgetSmall()
        WidgetMedium()
    }
}

fileprivate func generateCalendar(entry: MiniMonthTimelineEntry, traitEnv: UITraitEnvironment?, renderEvents: Bool) -> some View {
    let position: CalendarPosition = convert(entry.family) { value in
        switch value {
        case .systemSmall: return .small
        case .systemMedium: return .medium
        case .systemLarge: return .medium
        @unknown default: return .medium
        }
    }
    
    let preferencesDriver = PreferencesDriver()
    let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: nil)
    
    let rootInteractor = CalendarInteractor(style: .month, shortest: position.shouldDisplayShortestCaptions, renderEvents: renderEvents)
    let background = Image("paper").resizable(resizingMode: .stretch)
    
    return CalendarView(interactor: rootInteractor, position: position, background: background)
        .environmentObject(preferencesDriver)
        .environmentObject(designBook)
        .environment(\.adjustments, designBook.adjustments(position: position, size: entry.size))
}
