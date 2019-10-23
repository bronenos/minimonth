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
    let backwardAction: () -> Void
    let titleAction: () -> Void
    let forwardAction: () -> Void

    public var body: some View {
        HStack {
            WidgetHeaderButton(symbolName: "arrowtriangle.left.fill")
                .onTapGesture(perform: backwardAction)

            Spacer()
            
            Text(title)
                .font(.system(size: 19, weight: .semibold, design: .default))
                .kerning(3)
                .foregroundColor(Color.primary)
                .padding(.vertical, 6)
            .onTapGesture(perform: titleAction)

            Spacer()
            
            WidgetHeaderButton(symbolName: "arrowtriangle.right.fill")
                .onTapGesture(perform: forwardAction)
        }
        .padding(.horizontal)
    }
}
