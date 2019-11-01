//
//  HosterColorsBlock.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct HosterColorDynamicMeta: Hashable {
    let captionKey: String
    let lightKeyPath: PreferencesWritableKeyPath
    let darkKeyPath: PreferencesWritableKeyPath
}

struct HosterColorMeta: Hashable {
    let captionKey: String
    let keyPath: PreferencesWritableKeyPath
}

struct HosterColorsBlock: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    @EnvironmentObject var designBook: DesignBook
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var colorsResetAlerting = false

    var body: some View {
        VStack {
            ForEach(HosterColorDynamicMetaStorage().resolve(scheme: colorScheme), id: \.self) { meta in
                HosterColorControl(caption: meta.captionKey, keyPath: meta.keyPath)
            }
            
            Button(action: resetColorsAlertingPresent) {
                Text("Preferences.Colors.Reset")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
            }
            .padding(.top, 5)
        }
        .alert(isPresented: $colorsResetAlerting) {
            Alert(
                title: Text("Alert.ResetColors.Title"),
                message: Text("Alert.ResetColors.Message"),
                primaryButton: .destructive(
                    Text("Common.Confirm"),
                    action: self.resetColorsAlertingConfirm
                ),
                secondaryButton: .cancel()
            )
        }
    }
    
    private func resetColorsAlertingPresent() {
        colorsResetAlerting.toggle()
    }
    
    private func resetColorsAlertingConfirm() {
        preferencesDriver.resetColors()
        designBook.discardCache()
    }
}

fileprivate struct HosterColorDynamicMetaStorage {
    let metas: [HosterColorDynamicMeta] = [
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Month",
            lightKeyPath: \.monthTitleColorLight,
            darkKeyPath: \.monthTitleColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Arrows",
            lightKeyPath: \.navigationElementsColorLight,
            darkKeyPath: \.navigationElementsColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Axis",
            lightKeyPath: \.weekCaptionsColorLight,
            darkKeyPath: \.weekCaptionsColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Workday",
            lightKeyPath: \.workingDayColorLight,
            darkKeyPath: \.workingDayColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Weekend",
            lightKeyPath: \.weekendDayColorLight,
            darkKeyPath: \.weekendDayColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Today",
            lightKeyPath: \.currentDayColorLight,
            darkKeyPath: \.currentDayColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Event",
            lightKeyPath: \.shortEventColorLight,
            darkKeyPath: \.shortEventColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Holiday",
            lightKeyPath: \.fulldayEventColorLight,
            darkKeyPath: \.fulldayEventColorDark
        )
    ]
    
    func resolve(scheme: ColorScheme) -> [HosterColorMeta] {
        switch scheme {
        case .light: return metas.map { HosterColorMeta(captionKey: $0.captionKey, keyPath: $0.lightKeyPath) }
        case .dark: return metas.map { HosterColorMeta(captionKey: $0.captionKey, keyPath: $0.darkKeyPath) }
        @unknown default: return metas.map { HosterColorMeta(captionKey: $0.captionKey, keyPath: $0.lightKeyPath) }
        }
    }
}
