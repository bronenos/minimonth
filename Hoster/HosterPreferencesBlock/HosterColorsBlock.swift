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
    enum Alerting: Identifiable {
        case specificReset(HosterColorMeta)
        case entireReset
        
        var id: String {
            switch self {
            case .specificReset(let meta): return meta.captionKey
            case .entireReset: return String()
            }
        }
    }
    
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    @EnvironmentObject var designBook: DesignBook
    @EnvironmentObject private var context: HosterContext
    @Environment(\.colorScheme) private var colorScheme
    let colorApplier: (PreferencesWritableKeyPath) -> Void
    
    @State private var alerting: Alerting?

    var body: some View {
        VStack {
            ForEach(HosterColorDynamicMetaStorage().resolve(scheme: colorScheme), id: \.self) { meta in
                HosterColorControl(
                    caption: meta.captionKey,
                    keyPath: meta.keyPath,
                    colorApplier: colorApplier)
                    .onLongPressGesture {
                        self.alerting = .specificReset(meta)
                    }
            }
            
            Button(action: {alerting = .entireReset}) {
                Text("Preferences.Colors.ResetColors")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
            }
        }
        .alert(item: $alerting) { value in
            switch value {
            case .specificReset(let meta):
                return Alert(
                    title: Text(LocalizedStringKey(meta.captionKey)),
                    message: Text("Alert.ResetColor.Message"),
                    primaryButton: .destructive(
                        Text("Common.Confirm"),
                        action: {
                            context.storeColor(nil, forKeyPath: meta.keyPath)
                            preferencesDriver[keyPath: meta.keyPath] = nil
                            designBook.discardCache()
                        }
                    ),
                    secondaryButton: .cancel()
                )
            case .entireReset:
                return Alert(
                    title: Text("Alert.ResetColors.Title"),
                    message: Text("Alert.ResetColors.Message"),
                    primaryButton: .destructive(
                        Text("Common.Confirm"),
                        action: {
                            preferencesDriver.resetColors()
                            designBook.discardCache()
                        }
                    ),
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

fileprivate struct HosterColorDynamicMetaStorage {
    let metas: [HosterColorDynamicMeta] = [
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.Background",
            lightKeyPath: \.backgroundColorLight,
            darkKeyPath: \.backgroundColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.MonthTitle",
            lightKeyPath: \.monthTitleColorLight,
            darkKeyPath: \.monthTitleColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.NavigationElements",
            lightKeyPath: \.navigationElementsColorLight,
            darkKeyPath: \.navigationElementsColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.WeekCaptions",
            lightKeyPath: \.weekCaptionsColorLight,
            darkKeyPath: \.weekCaptionsColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.WorkdayNumbers",
            lightKeyPath: \.workingDayColorLight,
            darkKeyPath: \.workingDayColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.WeekendNumbers",
            lightKeyPath: \.weekendDayColorLight,
            darkKeyPath: \.weekendDayColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.CurrentDay",
            lightKeyPath: \.currentDayColorLight,
            darkKeyPath: \.currentDayColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.CurrentDayText",
            lightKeyPath: \.currentDayTextColorLight,
            darkKeyPath: \.currentDayTextColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.ShortEvents",
            lightKeyPath: \.shortEventColorLight,
            darkKeyPath: \.shortEventColorDark
        ),
        HosterColorDynamicMeta(
            captionKey: "Preferences.Colors.AllDayEvents",
            lightKeyPath: \.alldayEventColorLight,
            darkKeyPath: \.alldayEventColorDark
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
