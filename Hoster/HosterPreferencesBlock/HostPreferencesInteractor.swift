//
//  HostPreferencesInteractor.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Combine

final class HostPreferencesInteractor: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    var lookStyle = HosterLookStyle.auto {
        didSet { objectWillChange.send() }
    }
    
    var weeknumVisible = Bool(true) {
        didSet { objectWillChange.send() }
    }
}
