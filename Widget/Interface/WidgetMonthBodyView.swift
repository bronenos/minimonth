//
//  WidgetMonthBodyView.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct WidgetMonthBodyView: View {
    let weeksNumber: Int
    let monthOffset: Int
    let days: [WidgetDay]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(self.days, id: \.self) { day in
                    WidgetMonthDayView(day: day)
                        .frame(
                            width: self.step(inside: geometry).dx,
                            height: self.step(inside: geometry).dy,
                            alignment: .center)
                        .offset(
                            x: self.offsetX(inside: geometry, day: day),
                            y: self.offsetY(inside: geometry, day: day))
                }
            }
        }
    }
    
    private func step(inside geometry: GeometryProxy) -> CGVector {
        let x = geometry.size.width / 7.0
        let y = geometry.size.height / CGFloat(weeksNumber)
        return CGVector(dx: x, dy: y)
    }
    
    private func offsetX(inside geometry: GeometryProxy, day: WidgetDay) -> CGFloat {
        let index = (day.number + monthOffset - 1) % 7
        let value = step(inside: geometry).dx * CGFloat(index)
        return value
    }
    
    private func offsetY(inside geometry: GeometryProxy, day: WidgetDay) -> CGFloat {
        let index = (day.number + monthOffset - 1) / 7
        let value = step(inside: geometry).dy * CGFloat(index)
        return value
    }
}
