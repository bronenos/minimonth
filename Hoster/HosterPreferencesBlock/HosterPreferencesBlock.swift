//
//  HosterPreferencesBlock.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Combine

enum HosterLookStyle {
    case auto
    case light
    case dark
}

struct HosterPreferencesBlock: View {
    @ObservedObject private var interactor = HostPreferencesInteractor()
    
    var body: some View {
        VStack {
            Section {
                HStack {
                    Text("Preview as")
                    
                    Spacer()
                    
                    Picker(selection: $interactor.lookStyle, label: EmptyView()) {
                        Text("Auto").tag(HosterLookStyle.auto)
                        Text("Light").tag(HosterLookStyle.light)
                        Text("Dark").tag(HosterLookStyle.dark)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .styleAsPreferenceBlock()

            Section {
                Toggle(isOn: $interactor.weeknumVisible) {
                    Text("Show week numbers")
                }
            }
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
