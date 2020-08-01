//
//  DesignTypes.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct AdjustmentsKey: EnvironmentKey {
    static let defaultValue = DesignBookAdjustments(
        topSpacer: AnyView(Spacer()),
        headerMargins: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        captionHeight: 0,
        rowHeight: 0,
        eventMarkerSide: 0,
        dynamicVerticalAlignment: false,
        displayNavigationControls: false,
        displayEventAtBottom: false,
        displayAllWeekNumbers: false,
        horizontalMargins: 0,
        weekdayFont: .body,
        weekCaptionKind: .medium)
}

extension EnvironmentValues {
    var adjustments: DesignBookAdjustments {
        get { self[AdjustmentsKey.self] }
        set { self[AdjustmentsKey.self] = newValue }
    }
}

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
    public let weekNumberWidthCoef: CGFloat
}

public enum DesignWeekCaptionKind {
    case short
    case medium
}

public struct DesignBookAdjustments {
    public let topSpacer: AnyView
    public let headerMargins: EdgeInsets
    public let captionHeight: CGFloat
    public let rowHeight: CGFloat
    public let eventMarkerSide: CGFloat
    public let dynamicVerticalAlignment: Bool
    public let displayNavigationControls: Bool
    public let displayEventAtBottom: Bool
    public let displayAllWeekNumbers: Bool
    public let horizontalMargins: CGFloat
    public let weekdayFont: Font
    public let weekCaptionKind: DesignWeekCaptionKind
    
    public init(topSpacer: AnyView,
                headerMargins: EdgeInsets,
                captionHeight: CGFloat,
                rowHeight: CGFloat,
                eventMarkerSide: CGFloat,
                dynamicVerticalAlignment: Bool,
                displayNavigationControls: Bool,
                displayEventAtBottom: Bool,
                displayAllWeekNumbers: Bool,
                horizontalMargins: CGFloat,
                weekdayFont: Font,
                weekCaptionKind: DesignWeekCaptionKind) {
        self.topSpacer = topSpacer
        self.headerMargins = headerMargins
        self.captionHeight = captionHeight
        self.rowHeight = rowHeight
        self.eventMarkerSide = eventMarkerSide
        self.dynamicVerticalAlignment = dynamicVerticalAlignment
        self.displayNavigationControls = displayNavigationControls
        self.displayEventAtBottom = displayEventAtBottom
        self.displayAllWeekNumbers = displayAllWeekNumbers
        self.horizontalMargins = horizontalMargins
        self.weekdayFont = weekdayFont
        self.weekCaptionKind = weekCaptionKind
    }
}
