//
//  CalendarMonthdayView.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarMonthdayView: View {
    @EnvironmentObject var designBook: DesignBook

    let position: CalendarPosition
    let day: CalendarDay
    
    var body: some View {
        ZStack {
            Text("XX")
                .hidden()
                .padding(
                    convert(position) { value -> EdgeInsets in
                        switch value {
                        case .host: return EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
                        case .today: return EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
                        case .small: return EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6)
                        case .medium: return EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6)
                        }
                    }
                )
                .overlay(
                    Group {
                        if !position.shouldDisplayIndicator {
                            dayBlock
                        }
                        else if position.shouldDisplayIndicatorAtBottom {
                            VStack(spacing: 0) {
                                dayBlock
                                HStack {
                                    Spacer()
                                    indicatorBlock
                                    Spacer()
                                }
                                .offset(x: 0, y: -relativeOffset(hasEvent: day.options.hasAnyEvent()))
                            }
                            .offset(x: 0, y: relativeOffset(hasEvent: day.options.hasAnyEvent()))
                        }
                        else {
                            HStack(spacing: 0) {
                                dayBlock
                                VStack {
                                    Spacer()
                                    indicatorBlock
                                    Spacer()
                                }
                                .offset(x: -relativeOffset(hasEvent: day.options.hasAnyEvent()), y: 0)
                            }
                            .offset(x: relativeOffset(hasEvent: day.options.hasAnyEvent()), y: 0)
                        }
                    }
                )
            
            Text("\(day.number)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .foregroundColor(captionColor(forType: day.type))
        }
        .font(
            position.shouldReduceFontSize
                ? .system(size: 10, weight: .bold)
                : .system(size: 12, weight: .bold)
        )
    }
    
    private var dayBlock: some View {
        Capsule(style: .circular)
            .fill(designBook.cached(usage: .todayColor))
            .opacity(day.options.contains(.isToday) ? 1.0 : 0)
    }
    
    private var indicatorBlock: some View {
        Group {
            if day.options.contains(.hasLongEvent) {
                Circle()
                    .fill(designBook.cached(usage: .holidayColor))
                    .frame(ownSide: designBook.layout(position: position).eventMarkerSide)
            }
            
            if day.options.contains(.hasShortEvent) {
                Circle()
                    .fill(designBook.cached(usage: .eventColor))
                    .frame(ownSide: designBook.layout(position: position).eventMarkerSide)
            }
        }
    }
    
    fileprivate func relativeOffset(hasEvent: Bool) -> CGFloat {
        guard hasEvent else { return 0 }
        return designBook.layout(position: position).eventMarkerSide * 0.5
    }
    
    fileprivate func captionColor(forType type: CalendarDayType) -> Color {
        if day.options.contains(.isToday) {
            return designBook.cached(usage: .todayTextColor)
        }
        
        switch type {
        case .regular: return designBook.cached(usage: .workdayColor)
        case .weekend: return designBook.cached(usage: .weekendColor)
        case .holiday: return designBook.cached(usage: .holidayColor)
        }
    }
}
