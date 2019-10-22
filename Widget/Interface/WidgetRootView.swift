//
//  WidgetRootView.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

public struct WidgetRootView: View {
    @EnvironmentObject private var designBook: DesignBook
    @ObservedObject private var controller: WidgetController
    
    init(delegate: WidgetDelegate?) {
        controller = WidgetController(delegate: delegate)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                WidgetHeader(title: self.controller.meta.monthTitle)
                    .background(Color.red)
                
                HStack {
                    WidgetWeeknumBar(weekNumbers: self.controller.meta.weekNumbers)
                        .background(Color.green)
                        .frame(
                            width: geometry.size.width * self.designBook.layout.weekNumberWidthCoef)
                    
                    VStack {
                        WidgetWeekdayBar(captions: self.controller.meta.weekdayTitles)
                            .background(Color.blue)
                        
                        WidgetMonthBodyView(weeksNumber: self.controller.meta.weekNumbers.count,
                                            monthOffset: self.controller.meta.monthOffset,
                                            days: self.controller.meta.days)
                            .border(Color.yellow, width: 1)
                    }
                    .background(Color.white)
                }
                .background(Color.black)
                .background(Color.black)
            }
            .background(Color.gray)
            .onAppear(perform: self.controller.informToResize)
        }
    }
}
