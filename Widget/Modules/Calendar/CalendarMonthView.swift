//
//  CalendarMonthView.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarMonthView: View {
    let position: CalendarPosition
    let weeksNumber: Int
    let monthOffset: Int
    let days: [CalendarDay]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(self.days, id: \.self) { day in
                    CalendarMonthdayView(position: position, day: day)
                        .frame(
                            width: self.step(inside: geometry).dx,
                            height: self.step(inside: geometry).dy,
                            alignment: .center)
                        .position(
                            x: self.positionX(inside: geometry, day: day),
                            y: self.positionY(inside: geometry, day: day))
                }
            }
        }
    }
    
    private var dayOffset: Int {
        return (days.first?.number ?? 1) - 1
    }
    
    private func step(inside geometry: GeometryProxy) -> CGVector {
        let x = geometry.size.width / 7.0
        let y = geometry.size.height / CGFloat(weeksNumber)
        return CGVector(dx: x, dy: y)
    }
    
    private func positionX(inside geometry: GeometryProxy, day: CalendarDay) -> CGFloat {
        let index = (day.number - dayOffset + monthOffset - 1) % 7
        let offsetX = step(inside: geometry).dx * CGFloat(index)
        let positionX = offsetX + step(inside: geometry).dx * 0.5
        return positionX
    }
    
    private func positionY(inside geometry: GeometryProxy, day: CalendarDay) -> CGFloat {
        let index = (day.number - dayOffset + monthOffset - 1) / 7
        let offsetX = step(inside: geometry).dy * CGFloat(index)
        let positionY = offsetX + step(inside: geometry).dy * 0.5
        return positionY
    }
}
