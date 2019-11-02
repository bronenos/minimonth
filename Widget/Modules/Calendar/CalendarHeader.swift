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
    
    let title: String
    let year: Int?
    let fastBackwardAction: (() -> Void)?
    let backwardAction: (() -> Void)?
    let titleAction: () -> Void
    let forwardAction: (() -> Void)?
    let fastForwardAction: (() -> Void)?

    public var body: some View {
        HStack {
            CalendarHeaderButton(symbolName: "chevron.left.2")
                .opacity(fastBackwardAction == nil ? 0 : 1.0)
                .onTapGesture(perform: fastBackwardAction ?? {})

            CalendarHeaderButton(symbolName: "chevron.left")
                .padding(.horizontal, 10)
                .opacity(backwardAction == nil ? 0 : 1.0)
                .onTapGesture(perform: backwardAction ?? {})

            Spacer()
            
            Text(computedCaption)
                .font(.system(size: 17, weight: .semibold))
                .kerning(2)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(designBook.cached(usage: .monthColor))
                .padding(.vertical, 10)
                .onTapGesture(perform: titleAction)

            Spacer()
            
            CalendarHeaderButton(symbolName: "chevron.right")
                .padding(.horizontal, 10)
                .opacity(forwardAction == nil ? 0 : 1.0)
                .onTapGesture(perform: forwardAction ?? {})

            CalendarHeaderButton(symbolName: "chevron.right.2")
                .opacity(fastForwardAction == nil ? 0 : 1.0)
                .onTapGesture(perform: fastForwardAction ?? {})
        }
    }
    
    private var computedCaption: String {
        if let year = year {
            return "\(title) ʼ\(year % 100)"
        }
        else {
            return title
        }
    }
}
