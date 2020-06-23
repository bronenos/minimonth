//
//  HosterView.swift
//  MiniMonth-Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import MiniMonth
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
        ZStack {
            constructBackground()
            
            Group {
                if windowScene.interfaceOrientation.isPortrait {
                    constructPortraitContent()
                }
                else {
                    constructLandscapeContent()
                }
            }
            .padding(.horizontal, horizontalPadding)
            .sheet(
                item: $context.colorPickingSheet,
                content: constructColorPicker
            )
        }
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
    
    private func constructBackground() -> some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Color.clear
                    .background(Image(decorative: "launch_summer"))
                    .clipped()
                
                Color.clear
                    .background(Image(decorative: "launch_fall"))
                    .clipped()
            }
            
            HStack(alignment: .center, spacing: 0) {
                Color.clear
                    .background(Image(decorative: "launch_winter"))
                    .clipped()
                
                Color.clear
                    .background(Image(decorative: "launch_spring"))
                    .clipped()
            }
        }
        .compositingGroup()
        .blur(radius: 7)
        .overlay(Color(UIColor.systemBackground.withAlphaComponent(0.5)))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func constructPortraitContent() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            Spacer().frame(ownWidth: nil, ownHeight: 20)
            constructAboutBlock()
            HosterCalendarWrapper()
            constructPreferencesBlock()
        }
    }
    
    private func constructLandscapeContent() -> some View {
        VStack(alignment: .center, spacing: 0) {
            constructAboutBlock()
            
            HStack(alignment: .center) {
                HosterCalendarWrapper()
                
                if UIScreen.main.kind.atLeast(.extraLarge) {
                    Spacer().frame(minWidth: 5, idealWidth: 50, maxWidth: 50, alignment: .center)
                }
                else if UIScreen.main.kind.atLeast(.large) {
                    Spacer().frame(maxWidth: 30, alignment: .center)
                    
                }
                else if UIScreen.main.kind.atLeast(.regular) {
                    Spacer().frame(maxWidth: 30, alignment: .center)
                }
                else {
                    Spacer().frame(maxWidth: 5, alignment: .center)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    constructPreferencesBlock()
                }
            }
        }
    }
    
    private func constructAboutBlock() -> some View {
        Text("Hoster.Title")
            .font(.headline)
            .lineLimit(nil)
            .padding(.vertical)
    }
    
    private func constructPreferencesBlock() -> some View {
        HosterPreferencesBlock(
            preferencesDriver: preferencesDriver,
            colorScheme: colorScheme,
            colorApplier: applyColorPicker,
            delegate: delegate)
    }
    
    private func constructColorPicker(item: HosterContextColorPickingMeta) -> some View {
        HosterColorPickerSheet(
            context: context,
            title: item.title,
            keyPath: item.keyPath,
            selectedColor: preferencesDriver[keyPath: item.keyPath].mixWithBaseColor(UIColor.systemBackground))
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
