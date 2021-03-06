//
//  CalendarViewWrapper.swift
//  Widget
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

public struct CalendarViewWrapper: View {
    private let interactor: CalendarInteractor
    private let position: CalendarPosition
    private let preferencesDriver: PreferencesDriver
    private let designBook: DesignBook
    
    public init(interactor: CalendarInteractor,
                position: CalendarPosition,
                preferencesDriver: PreferencesDriver,
                designBook: DesignBook) {
        self.interactor = interactor
        self.position = position
        self.preferencesDriver = preferencesDriver
        self.designBook = designBook
    }
    
    public var body: some View {
        CalendarView(interactor: interactor, position: position, background: Color.clear)
            .environmentObject(preferencesDriver)
            .environmentObject(designBook)
            .environment(\.adjustments, designBook.adjustments(position: .today, size: .zero))
    }
}
