//
//  CalendarViewWrapper.swift
//  Widget
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

public struct CalendarViewWrapper: View {
    private let interactor: CalendarInteractor
    private let preferencesDriver: PreferencesDriver
    private let designBook: DesignBook
    
    public init(interactor: CalendarInteractor,
                preferencesDriver: PreferencesDriver,
                designBook: DesignBook) {
        self.interactor = interactor
        self.preferencesDriver = preferencesDriver
        self.designBook = designBook
    }
    
    public var body: some View {
        CalendarView(interactor: interactor)
            .environmentObject(preferencesDriver)
            .environmentObject(designBook)
    }
}
