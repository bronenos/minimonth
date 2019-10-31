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
                .padding(.vertical, 4)
            
            ZStack {
                Color(UIColor.secondarySystemBackground)
                Spacer()
            }
            
            Circle()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(minWidth: 15, idealWidth: 25, maxWidth: 25, alignment: .center)
                .foregroundColor(resolvedColor)
                .padding(5)
        }
        .overlay(
            Capsule(style: .circular)
                .stroke(Color.gray)
                .opacity(0.35))
        .onTapGesture {
            self.context.presentColorPicker(title: self.caption, keyPath: self.keyPath)
        }
    }
    
    private var resolvedColor: Color {
        return Color(preferencesDriver[keyPath: keyPath])
    }
}
