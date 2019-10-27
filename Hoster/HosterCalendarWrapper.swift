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
        CalendarView(
            interactor: CalendarInteractor(style: .month, delegate: nil),
            position: .center)
            .frame(ownWidth: 350, ownHeight: 300)
            .background(BlurredView(style: .systemThickMaterial, backgroundColor: UIColor.label))
            .cornerRadius(20)
            .disabled(true)
    }
}
