//
//  RangeExtensions.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation

extension Range where Bound == Int {
    static var empty: Range<Bound> { 0 ..< 1 }
    
    static func only(_ value: Bound) -> Range<Bound> {
        value ..< value + 1
    }
}
