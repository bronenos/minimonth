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
            if self.windowScene.interfaceOrientation.isPortrait {
                if UIDevice.current.hasLargeScreen {
                    VStack {
                        Spacer()
                        
                        HosterCalendarWrapper()

                        HosterPreferencesBlock(
                            preferencesDriver: self.preferencesDriver,
                            colorScheme: self.colorScheme,
                            delegate: self.delegate)
                        
                        Spacer()
                    }
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer()
                            .frame(ownWidth: nil, ownHeight: 20)
                        
                        HosterCalendarWrapper()

                        HosterPreferencesBlock(
                            preferencesDriver: self.preferencesDriver,
                            colorScheme: self.colorScheme,
                            delegate: self.delegate)
                            .layoutPriority(1.0)
                    }
                }
            }
            else {
                HStack(alignment: .center) {
                    HosterCalendarWrapper()
                    
                    if UIDevice.current.hasLargeScreen {
                        Spacer()
                            .frame(minWidth: 0, idealWidth: 50, maxWidth: 50, alignment: .center)
                        
                        VStack {
                            Spacer()
                            
                            HosterPreferencesBlock(
                                preferencesDriver: self.preferencesDriver,
                                colorScheme: self.colorScheme,
                                delegate: self.delegate)
                            
                            Spacer()
                        }
                    }
                    else {
                        ScrollView(.vertical, showsIndicators: false) {
                            HosterPreferencesBlock(
                                preferencesDriver: self.preferencesDriver,
                                colorScheme: self.colorScheme,
                                delegate: self.delegate)
                        }
                    }
                }
            }
        }
        .background(Color(UIColor.systemBackground))
        .padding(.horizontal, 15)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
        .sheet(
            item: self.$context.colorPickingMeta,
            content: self.constructColorPicker
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
