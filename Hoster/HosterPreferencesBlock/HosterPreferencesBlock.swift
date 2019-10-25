//
//  HosterPreferencesBlock.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared
import Combine

struct HosterPreferencesBlock: View {
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @ObservedObject private var interactor: HostPreferencesInteractor
    
    init(preferencesDriver: PreferencesDriver, colorScheme: ColorScheme, delegate: HosterViewDelegate?) {
        interactor = HostPreferencesInteractor(
            preferencesDriver: preferencesDriver,
            colorScheme: colorScheme,
            delegate: delegate
        )
    }
    
    var body: some View {
        VStack {
            Section {
                HStack {
                    Text("Preview as")
                    
                    Spacer()
                    
                    Picker(selection: $interactor.colorScheme, label: EmptyView()) {
                        Text("Light").tag(ColorScheme.light)
                        Text("Dark").tag(ColorScheme.dark)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(.horizontal, 15)
            .styleAsPreferenceBlock()

            Section {
                Toggle(isOn: $interactor.weeknumVisible) {
                    Text("Show week numbers")
                }
            }
            .padding(.horizontal, 15)
            .styleAsPreferenceBlock()
            
            Section {
                HosterColorsBlock()
            }
            .styleAsPreferenceBlock()
        }
    }
}

fileprivate extension View {
    func styleAsPreferenceBlock() -> some View {
        return self
            .padding(10)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
    }
}
