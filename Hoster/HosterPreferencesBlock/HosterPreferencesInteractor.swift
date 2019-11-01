//
//  HosterPreferencesInteractor.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Combine

final class HosterPreferencesInteractor: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    private let preferencesDriver: PreferencesDriver
    private weak var delegate: HosterViewDelegate?
    
    init(preferencesDriver: PreferencesDriver,
         colorScheme: ColorScheme,
         delegate: HosterViewDelegate?) {
        self.preferencesDriver = preferencesDriver
        self.colorScheme = colorScheme
        self.delegate = delegate
    }
    
    var colorScheme: ColorScheme {
        didSet {
            delegate?.didRequestStyleUpdate(colorScheme)
            objectWillChange.send()
        }
    }
    
    var weeknumVisible: Bool {
        get {
            return preferencesDriver.shouldDisplayWeekNumbers
        }
        set {
            preferencesDriver.shouldDisplayWeekNumbers = newValue
            objectWillChange.send()
        }
    }
}
