//
//  CalendarHeaderButton.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarHeaderButton: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    
    let symbolName: String
    
    public var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color(preferencesDriver.navigationColor))
    }
}
