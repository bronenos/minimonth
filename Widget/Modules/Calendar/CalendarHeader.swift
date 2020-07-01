//
//  CalendarHeader.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarHeader: View {
    @EnvironmentObject var designBook: DesignBook
    
    let position: CalendarPosition
    let weekNumber: Int
    let title: String
    let year: Int?
    let fastBackwardAction: (() -> Void)?
    let backwardAction: (() -> Void)?
    let titleAction: () -> Void
    let forwardAction: (() -> Void)?
    let fastForwardAction: (() -> Void)?

    public var body: some View {
        HStack {
            if position.shouldDisplayControls {
                CalendarHeaderButton(symbolName: "chevron.left.2")
                    .opacity(fastBackwardAction == nil ? 0 : 1.0)
                    .onTapGesture(perform: fastBackwardAction ?? {})

                CalendarHeaderButton(symbolName: "chevron.left")
                    .padding(.horizontal, 10)
                    .opacity(backwardAction == nil ? 0 : 1.0)
                    .onTapGesture(perform: backwardAction ?? {})
            }

            Spacer()
            
            HStack(alignment: .lastTextBaseline) {
                if !position.shouldDisplayWeekNumbers, !position.shouldDisplayControls, weekNumber > 0 {
                    Text("# \(weekNumber)")
                        .font(.system(size: 12, weight: .semibold))
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(designBook.cached(usage: .captionColor))
                    
                    Spacer()
                }
                
                Text(computedCaption)
                    .font(.system(size: 17, weight: .semibold))
                    .kerning(2)
                    .fixedSize(horizontal: true, vertical: false)
                    .foregroundColor(designBook.cached(usage: .monthColor))
                    .padding(.vertical, convert(position) { value in
                        switch value {
                        case .host: return 10
                        case .today: return 10
                        case .small: return 3
                        case .medium: return 3
                        }
                    })
                    .onTapGesture(perform: titleAction)
            }

            Spacer()
            
            if position.shouldDisplayControls {
                CalendarHeaderButton(symbolName: "chevron.right")
                    .padding(.horizontal, 10)
                    .opacity(forwardAction == nil ? 0 : 1.0)
                    .onTapGesture(perform: forwardAction ?? {})

                CalendarHeaderButton(symbolName: "chevron.right.2")
                    .opacity(fastForwardAction == nil ? 0 : 1.0)
                    .onTapGesture(perform: fastForwardAction ?? {})
            }
        }
    }
    
    private var computedCaption: String {
        if let year = year, position.shouldDisplayControls {
            return "\(title) ʼ\(year % 100)"
        }
        else {
            return title
        }
    }
}
