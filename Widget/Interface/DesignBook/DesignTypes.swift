//
//  DesignTypes.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit

enum DesignBookStyle {
    case light
    case dark
}

enum DesignBookColor {
    case native(UIColor)
    case hex(Int)
    case usage(DesignBookColorUsage)
}

enum DesignBookColorUsage {
    // global
    case white
    case black
    // foregrounds
    case primaryForeground
}

struct DesignBookFontSize {
    let compact: CGFloat
    let regular: CGFloat
}

enum DesignBookFontWeight {
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
}

struct DesignBookLayout {
    let weekHeaderHeight: CGFloat
    let weekNumberWidthCoef: CGFloat
    let weekDayHeight: CGFloat
}
