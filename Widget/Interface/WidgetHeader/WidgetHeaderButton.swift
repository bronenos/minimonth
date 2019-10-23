//
//  WidgetHeaderButton.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct WidgetHeaderButton: View {
    let symbolName: String
    
    public var body: some View {
        Image(systemName: symbolName)
            .font(.callout)
            .foregroundColor(Color.primary)
            .opacity(0.6)
    }
}
