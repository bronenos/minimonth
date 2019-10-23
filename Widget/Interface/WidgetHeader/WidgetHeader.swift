//
//  WidgetHeader.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct WidgetHeader: View {
    let title: String
    let year: Int?
    let fastBackwardAction: () -> Void
    let backwardAction: () -> Void
    let titleAction: () -> Void
    let forwardAction: () -> Void
    let fastForwardAction: () -> Void

    public var body: some View {
        HStack {
            WidgetHeaderButton(symbolName: "chevron.left.2")
                .onTapGesture(perform: fastBackwardAction)

            WidgetHeaderButton(symbolName: "chevron.left")
                .onTapGesture(perform: backwardAction)
            
            Spacer()
            
            Text(computedCaption)
                .font(.system(size: 19, weight: .semibold, design: .default))
                .kerning(2)
                .foregroundColor(Color.primary)
                .padding(.vertical, 6)
            .onTapGesture(perform: titleAction)

            Spacer()
            
            WidgetHeaderButton(symbolName: "chevron.right")
                .onTapGesture(perform: forwardAction)
            
            WidgetHeaderButton(symbolName: "chevron.right.2")
                .onTapGesture(perform: fastForwardAction)
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
