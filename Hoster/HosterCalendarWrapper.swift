//
//  HosterCalendarWrapper.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

struct HosterCalendarWrapper: View {
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @EnvironmentObject private var designBook: DesignBook

    var body: some View {
        VStack {
            Spacer()
            
            CalendarView(
                interactor: CalendarInteractor(style: .month, delegate: nil))
            
            Spacer()
        }
        .frame(ownSide: 350)
    }
}
