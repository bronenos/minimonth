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

    let day: CalendarDay
    
    var body: some View {
        ZStack {
            Text("\(day.number)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .foregroundColor(captionColor(forType: day.type))

            Text("XX")
                .hidden()
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .overlay(
                    VStack(spacing: 0) {
                        Capsule(style: .circular)
                            .stroke(designBook.cached(usage: .todayColor))
                            .opacity(day.options.contains(.isToday) ? 1.0 : 0)
                        
                        HStack {
                            Spacer()
                            
                            if day.options.contains(.hasLongEvent) {
                                Circle()
                                    .fill(designBook.cached(usage: .holidayColor))
                                    .frame(ownSide: designBook.layout.eventMarkerSide)
                            }
                            
                            if day.options.contains(.hasShortEvent) {
                                Circle()
                                    .fill(designBook.cached(usage: .eventColor))
                                    .frame(ownSide: designBook.layout.eventMarkerSide)
                            }
                            
                            Spacer()
                        }
                        .offset(x: 0, y: -relativeTopOffset(hasEvent: day.options.hasAnyEvent()))
                    }
                    .offset(x: 0, y: relativeTopOffset(hasEvent: day.options.hasAnyEvent())))
        }
        .font(.system(size: 12, weight: .bold))
    }
    
    fileprivate func relativeTopOffset(hasEvent: Bool) -> CGFloat {
        guard hasEvent else { return 0 }
        return designBook.layout.eventMarkerSide * 0.5
    }
    
    fileprivate func captionColor(forType type: CalendarDayType) -> Color {
        switch type {
        case .regular: return designBook.cached(usage: .workdayColor)
        case .weekend: return designBook.cached(usage: .weekendColor)
        case .holiday: return designBook.cached(usage: .holidayColor)
        }
    }
}
