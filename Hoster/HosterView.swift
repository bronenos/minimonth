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

protocol HosterViewDelegate: class {
    func didRequestStyleUpdate(_ style: ColorScheme?)
}

struct HosterView: View {
    @EnvironmentObject private var designBook: DesignBook
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @Environment(\.colorScheme) var colorScheme
    
    let windowScene: UIWindowScene
    let delegate: HosterViewDelegate?

    var body: some View {
        Group {
            if windowScene.interfaceOrientation.isPortrait {
                VStack(alignment: .center, spacing: 50) {
                    HosterCalendarWrapper()
                    
                    HosterPreferencesBlock(
                        preferencesDriver: preferencesDriver,
                        colorScheme: colorScheme,
                        delegate: delegate
                    )
                }
            }
            else {
                HStack(alignment: .center, spacing: 50) {
                    HosterCalendarWrapper()
                    
                    HosterPreferencesBlock(
                        preferencesDriver: preferencesDriver,
                        colorScheme: colorScheme,
                        delegate: delegate
                    )
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
        EmptyView()
//        HosterView(windowScene: <#UIWindowScene#>, delegate: nil)
//            .environmentObject(designBook)
//            .environment(\.verticalSizeClass, .compact)
//            .environment(\.horizontalSizeClass, .compact)
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
#endif
