//
//  HosterView.swift
//  MiniMonth-Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared
import Widget

struct HosterView: View {
    @EnvironmentObject private var designBook: DesignBook
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                VStack(alignment: .center, spacing: 50) {
                    HosterCalendarWrapper()
                    HosterPreferencesBlock()
                }
            }
            else {
                HStack(alignment: .center, spacing: 50) {
                    HosterCalendarWrapper()
                    HosterPreferencesBlock()
                }
            }
        }
        .background(Color(UIColor.systemBackground))
        .padding(.horizontal, 15)
    }
}

#if DEBUG
private final class MockTraitEnvironment: NSObject, UITraitEnvironment {
    var traitCollection = UITraitCollection(traitsFrom: [.init(horizontalSizeClass: .compact), .init(horizontalSizeClass: .compact)])
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { }
}

private let traitEnvironment = MockTraitEnvironment()
private let preferencesDriver = PreferencesDriver()
private let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: traitEnvironment)

struct HosterView_Previews: PreviewProvider {
    static var previews: some View {
        HosterView()
            .environmentObject(designBook)
            .environment(\.verticalSizeClass, .compact)
            .environment(\.horizontalSizeClass, .compact)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
#endif
