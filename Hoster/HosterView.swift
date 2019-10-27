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
import Combine
import ColorPicker

protocol HosterViewDelegate: class {
    func didRequestStyleUpdate(_ style: ColorScheme?)
}

struct HosterView: View {
    @EnvironmentObject private var designBook: DesignBook
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @EnvironmentObject private var context: HosterContext
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var orientationWatcher: OrientationWatcher
    
    let windowScene: UIWindowScene
    let delegate: HosterViewDelegate?
    
    private var pickingColor = Color.primary
    
    init(windowScene: UIWindowScene, delegate: HosterViewDelegate?) {
        self.windowScene = windowScene
        self.delegate = delegate
        self.orientationWatcher = OrientationWatcher(windowScene: windowScene)
    }

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
                    .fixedSize(horizontal: false, vertical: true)
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
        .sheet(
            item: $context.colorPickingMeta,
            content: constructColorPicker
        )
    }
    
    private func constructColorPicker(item: HosterContextColorPickingMeta) -> some View {
        HosterColorPickerWrapper(
            context: context,
            title: item.title,
            keyPath: item.keyPath,
            selectedColor: preferencesDriver[keyPath: item.keyPath])
            .onDisappear { self.applyColorPicker(keyPath: item.keyPath) }
    }
    
    private func applyColorPicker(keyPath: PreferencesWritableKeyPath) {
        guard let pickedColor = context.retrieveColor(forKeyPath: keyPath) else { return }
        preferencesDriver[keyPath: keyPath] = pickedColor
        designBook.discardCache()
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
    }
}
#endif
