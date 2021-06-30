//
//  HosterColorControl.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct HosterColorControl: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    @EnvironmentObject private var context: HosterContext

    let caption: String
    let keyPath: PreferencesWritableKeyPath
    let colorApplier: (PreferencesWritableKeyPath) -> Void
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            
            HStack {
                Text(localizedCaption)
                    .font(.body)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 11)
                    .padding(.vertical, 8)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Capsule()
                    .frame(ownWidth: 40, ownHeight: 30)
                    .foregroundColor(resolvedColor)
                    .padding(6)
            }
        }
        .overlay(
            Capsule(style: .circular)
                .stroke(Color.gray)
                .opacity(0.35))
        .onTapGesture {
            self.context.presentColorPicker(
                title: NSLocalizedString(self.caption, comment: String()),
                keyPath: self.keyPath
            )
        }
    }
    
    private var localizedCaption: LocalizedStringKey {
        return LocalizedStringKey(caption)
    }
    
    private var resolvedColor: Color {
        return Color(preferencesDriver[keyPath: keyPath] ?? .black)
    }
}
