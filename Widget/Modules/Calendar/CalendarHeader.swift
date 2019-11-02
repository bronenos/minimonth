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
                .opacity(fastBackwardAction.hasValue ? 1.0 : 0)
                .onTapGesture(perform: fastBackwardAction ?? {})

            CalendarHeaderButton(symbolName: "chevron.left")
                .padding(.horizontal, 10)
                .opacity(backwardAction.hasValue ? 1.0 : 0)
                .onTapGesture(perform: backwardAction ?? {})

            Spacer()
            
            Text(computedCaption)
                .font(.system(size: 17, weight: .semibold))
                .kerning(2)
                .foregroundColor(designBook.cached(usage: .monthColor))
                .padding(.vertical, 15)
                .onTapGesture(perform: titleAction)

            Spacer()
            
            CalendarHeaderButton(symbolName: "chevron.right")
                .padding(.horizontal, 10)
                .opacity(forwardAction.hasValue ? 1.0 : 0)
                .onTapGesture(perform: forwardAction ?? {})

            CalendarHeaderButton(symbolName: "chevron.right.2")
                .opacity(fastForwardAction.hasValue ? 1.0 : 0)
                .onTapGesture(perform: fastForwardAction ?? {})
        }
        .padding(.horizontal)
    }
    
    private var computedCaption: String {
        if let year = year {
            return "\(title) (\(year))"
        }
        else {
            return title
        }
    }
}
