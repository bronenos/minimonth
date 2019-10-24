//
//  FoundationExtensions.swift
//  Today
//
//  Created by Stan Potemkin on 24.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Foundation

func convert<Source, Target>(_ value: Source, block: (Source) -> Target) -> Target {
    return block(value)
}
