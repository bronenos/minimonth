//
//  OptionalExtensions.swift
//  Today
//
//  Created by Stan Potemkin on 24.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

extension Optional {
    var hasValue: Bool {
        return (self != nil)
    }
}
