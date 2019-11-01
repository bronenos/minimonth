//
//  HosterView.swift
//  MiniMonth-Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Widget
import Combine

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
                constructPortraitContent()
            }
            else {
                constructLandscapeContent()
            }
        }
        .background(Color(UIColor.systemBackground))
        .padding(.horizontal, horizontalPadding)
        .sheet(
            item: $context.colorPickingMeta,
            content: constructColorPicker
        )
    }
    
    private var horizontalPadding: CGFloat {
        if windowScene.interfaceOrientation.isPortrait {
            return 15
        }
        else if UIScreen.main.kind.atLeast(.regular) {
            return 15
        }
        else {
            return 5
        }
    }
    
    private func constructPortraitContent() -> some View {
        Group {
            if UIScreen.main.kind.atLeast(.extraLarge) {
                VStack {
                    Spacer()
                    HosterCalendarWrapper()
                    constructPreferencesBlock()
                    Spacer()
                }
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer().frame(ownWidth: nil, ownHeight: 20)
                    HosterCalendarWrapper()
                    constructPreferencesBlock()
                }
            }
        }
    }
    
    private func constructLandscapeContent() -> some View {
        HStack(alignment: .center) {
            HosterCalendarWrapper()
            
            if UIScreen.main.kind.atLeast(.extraLarge) {
                Spacer().frame(minWidth: 5, idealWidth: 50, maxWidth: 50, alignment: .center)
                
                VStack {
                    Spacer()
                    constructPreferencesBlock()
                    Spacer()
                }
            }
            else if UIScreen.main.kind.atLeast(.large) {
                Spacer().frame(maxWidth: 30, alignment: .center)
                
                ScrollView(.vertical, showsIndicators: false) {
                    constructPreferencesBlock()
                }
            }
            else if UIScreen.main.kind.atLeast(.regular) {
                Spacer().frame(maxWidth: 30, alignment: .center)
                
                ScrollView(.vertical, showsIndicators: false) {
                    constructPreferencesBlock()
                }
            }
            else {
                Spacer().frame(maxWidth: 5, alignment: .center)
                
                ScrollView(.vertical, showsIndicators: false) {
                    constructPreferencesBlock()
                }
            }
        }
    }
    
    private func constructPreferencesBlock() -> some View {
        HosterPreferencesBlock(
            preferencesDriver: preferencesDriver,
            colorScheme: colorScheme,
            delegate: delegate)
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
