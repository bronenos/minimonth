//
//  DesignTypes.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

public enum DesignBookColor {
    case native(UIColor)
    case hex(Int)
    case usage(DesignBookColorUsage)
    case pref(PreferencesReadableKeyPath)
}

public enum DesignBookColorUsage {
    // global
    case white
    case black
    // foregrounds
    case primaryForeground
    // preferences
    case monthColor
    case navigationColor
    case captionColor
    case workdayColor
    case weekendColor
    case holidayColor
    case todayColor
    case todayTextColor
    case eventColor
}

public struct DesignBookFontSize {
    public let compact: CGFloat
    public let regular: CGFloat
}

public enum DesignBookFontWeight {
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
}

public struct DesignBookLayout {
    public let weekHeaderHeight: CGFloat
    public let weekNumberWidthCoef: CGFloat
    public let weekDayHeight: CGFloat
    public let eventMarkerSide: CGFloat
}
