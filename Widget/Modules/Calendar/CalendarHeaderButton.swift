//
//  CalendarHeaderButton.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

struct CalendarHeaderButton: View {
    @EnvironmentObject var designBook: DesignBook

    let symbolName: String
    
    public var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(designBook.cached(usage: .navigationColor))
    }
}
