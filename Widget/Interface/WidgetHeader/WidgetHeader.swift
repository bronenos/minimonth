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
    let fastBackwardAction: (() -> Void)?
    let backwardAction: (() -> Void)?
    let titleAction: () -> Void
    let forwardAction: (() -> Void)?
    let fastForwardAction: (() -> Void)?

    public var body: some View {
        HStack {
            if fastBackwardAction != nil {
                WidgetHeaderButton(symbolName: "chevron.left.2")
                    .onTapGesture(perform: fastBackwardAction ?? {})
            }

            if backwardAction != nil {
                WidgetHeaderButton(symbolName: "chevron.left")
                    .padding(.horizontal, 10)
                    .onTapGesture(perform: backwardAction ?? {})
            }
            
            Spacer()
            
            Text(computedCaption)
                .font(.system(size: 19, weight: .semibold))
                .kerning(2)
                .foregroundColor(Color.primary)
                .padding(.vertical, 6)
            .onTapGesture(perform: titleAction)

            Spacer()
            
            if forwardAction != nil {
                WidgetHeaderButton(symbolName: "chevron.right")
                    .padding(.horizontal, 10)
                    .onTapGesture(perform: forwardAction ?? {})
            }
            
            if fastForwardAction != nil {
                WidgetHeaderButton(symbolName: "chevron.right.2")
                    .onTapGesture(perform: fastForwardAction ?? {})
            }
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
