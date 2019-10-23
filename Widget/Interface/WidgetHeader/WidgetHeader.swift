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
    
    public var body: some View {
        HStack {
            WidgetHeaderButton(symbolName: "arrowtriangle.left.fill")

            Spacer()
            
            Text(title)
                .font(.system(size: 19, weight: .bold, design: .default))
                .kerning(3)
                .foregroundColor(Color.primary)
                .padding(.vertical, 6)
            
            Spacer()
            
            WidgetHeaderButton(symbolName: "arrowtriangle.right.fill")
        }
        .padding(.horizontal)
    }
}
