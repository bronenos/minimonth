//
//  WidgetMonthDay.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct WidgetMonthDayView: View {
    @EnvironmentObject var designBook: DesignBook
    
    let day: WidgetDay
    
    var body: some View {
        ZStack {
            Text("\(day.number)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .foregroundColor(captionColor(forType: day.type))

            Text("XX")
                .hidden()
                .padding(.vertical, 4)
                .padding(.horizontal, 7)
                .overlay(
                    VStack(spacing: 0) {
                        Capsule(style: .circular)
                            .stroke(Color.green)
                            .opacity(day.options.contains(.isToday) ? 1.0 : 0)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(ownSide: designBook.layout.eventMarkerSide)
                            .offset(x: 0, y: -designBook.layout.eventMarkerSide * 0.5)
                            .opacity(day.options.contains(.hasEvent) ? 1.0 : 0)
                    }
                    .offset(x: 0, y: designBook.layout.eventMarkerSide * 0.5))
        }
        .font(.system(size: 12, weight: .bold))
    }
    
    fileprivate func captionColor(forType type: WidgetDayType) -> Color {
        switch type {
        case .regular: return .primary
        case .weekend: return .red
        case .holiday: return .primary
        }
    }
}
