//
//  HosterColorControl.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

struct HosterColorControl: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    @EnvironmentObject private var context: HosterContext

    let caption: String
    let keyPath: PreferencesWritableKeyPath
    
    var body: some View {
        HStack {
            Text(caption)
                .font(.callout)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: true, vertical: true)
                .padding(.leading, 8)
                .padding(.vertical, 8)
            
            Spacer()
            
            Circle()
                .foregroundColor(resolvedColor)
                .frame(ownSide: 35)
        }
        .overlay(
            Capsule(style: .circular)
                .stroke(resolvedColor)
                .opacity(0.75))
        .onTapGesture {
            self.context.presentColorPicker(title: self.caption, keyPath: self.keyPath)
        }
    }
    
    private var resolvedColor: Color {
        return Color(preferencesDriver[keyPath: keyPath])
    }
}
