//
//  WidgetMonthDay.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct WidgetMonthDayView: View {
    let day: WidgetDay
    
    var body: some View {
        ZStack {
            Text("\(day.number)")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            if day.options.contains(.isToday) {
                Text("XX")
                    .hidden()
                    .padding(.vertical, 2)
                    .padding(.horizontal, 7)
                    .overlay(
                        Capsule(style: .circular).stroke(Color.green))
            }
            
            if day.options.contains(.hasEvent) {
                Circle()
                    .fill(Color.red)
                    .frame(ownWidth: 3, ownHeight: 3)
                    .offset(x: 0, y: 12)
            }
        }
        .font(.system(size: 12, weight: .bold, design: .default))
    }
}
