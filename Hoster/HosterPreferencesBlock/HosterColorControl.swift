//
//  HosterColorControl.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct HosterColorControl: View {
    let caption: String
    let color: UIColor
    
    var body: some View {
        HStack {
            Text(caption)
                .font(.body)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: true, vertical: true)
            
            Spacer()
            
            Circle()
                .foregroundColor(Color(color))
                .frame(ownWidth: 25, ownHeight: 25)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 15)
    }
}
