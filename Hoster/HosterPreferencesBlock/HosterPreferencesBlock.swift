//
//  HosterPreferencesBlock.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Combine

struct HosterPreferencesBlock: View {
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @ObservedObject private var interactor: HosterPreferencesInteractor
    
    init(preferencesDriver: PreferencesDriver, colorScheme: ColorScheme, delegate: HosterViewDelegate?) {
        interactor = HosterPreferencesInteractor(
            preferencesDriver: preferencesDriver,
            colorScheme: colorScheme,
            delegate: delegate
        )
    }
    
    var body: some View {
//        HStack(alignment: .center) {
            VStack {
                Spacer()
                
                Section {
                    HStack {
                        Text("Preferences.PreviewAs")
                        
                        Spacer()
                        
                        Picker(selection: $interactor.colorScheme, label: EmptyView()) {
                            Text("Preferences.PreviewAs.Light").tag(ColorScheme.light)
                            Text("Preferences.PreviewAs.Dark").tag(ColorScheme.dark)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .styleAsPreferenceBlock()

                Section {
                    Toggle(isOn: $interactor.weeknumVisible) {
                        Text("Preferences.WeekNumbers")
                    }
                    .offset(x: -2, y: 0)
                }
                .styleAsPreferenceBlock()
                .padding(.bottom, 5)
                
                Section {
                    HosterColorsBlock()
                        .padding(.top, 5)
                }
                .styleAsPreferenceBlock()
                
                Spacer()
            }
//        }
        .padding(.vertical, 15)
        .frame(maxWidth: 400, alignment: .center)
        .fixedSize(horizontal: false, vertical: true)
    }
}

fileprivate extension View {
    func styleAsPreferenceBlock() -> some View {
        return self
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
    }
}
