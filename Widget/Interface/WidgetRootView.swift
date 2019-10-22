//
//  WidgetRootView.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

public struct WidgetRootView: View {
    @EnvironmentObject var designBook: DesignBook
    @ObservedObject var controller = WidgetController()
    
    public var body: some View {
        VStack {
            WidgetHeader(
                title: controller.meta.monthTitle
            )
            
            HStack {
                GeometryReader { geometry in
                    WidgetWeeknumBar()
                        .frame(
                            width: geometry.size.width * self.designBook.layout.weekNumberWidthCoef,
                            height: geometry.size.height)
                    
                    VStack {
                        WidgetWeekdayBar(
                            captions: self.controller.meta.weekdayTitles
                        )
                        
                        WidgetMonthBodyView(
                            weeksNumber: self.controller.meta.weekNumbers.count,
                            monthOffset: self.controller.meta.monthOffset,
                            days: self.controller.meta.days
                        ).frame(
                            height: geometry.size.width * self.designBook.layout.weekDayRatio)
                    }
                }
            }
        }
    }
}
