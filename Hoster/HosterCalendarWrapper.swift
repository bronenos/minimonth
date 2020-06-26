//
//  HosterCalendarWrapper.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct HosterCalendarWrapper: View {
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @EnvironmentObject private var designBook: DesignBook

    var body: some View {
        let interactor = CalendarInteractor(
            style: .month,
            shortest: false)
        
        return CalendarView(interactor: interactor, position: .host, background: Color(.secondarySystemBackground))
            .frame(
                minWidth: 250, idealWidth: 300, maxWidth: 350,
                minHeight: 270, idealHeight: 280, maxHeight: 280,
                alignment: .center)
            .cornerRadius(20)
            .disabled(true)
    }
}
