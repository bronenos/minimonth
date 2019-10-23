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
    
    init(controller: WidgetController) {
        self.controller = controller
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                WidgetHeader(
                    title: self.controller.meta.monthTitle,
                    backwardAction: self.controller.switchToPreviousMonth,
                    titleAction: self.controller.switchToCurrentMonth,
                    forwardAction: self.controller.switchToNextMonth)
                
                WidgetWeekdayBar(
                    captions: self.controller.meta.weekdayTitles)
                    .frame(ownHeight: self.designBook.layout.weekHeaderHeight)
                    .padding(.leading, self.calculateWeeknumWidth(geometry: geometry))
                
                HStack(spacing: 0) {
                    WidgetWeeknumBar(
                        weekNumbers: self.controller.meta.weekNumbers)
                        .frame(ownWidth: self.calculateWeeknumWidth(geometry: geometry))
                        .modifier(self.calculateBodyHeightModifier(geometry: geometry))

                    WidgetMonthBodyView(
                        weeksNumber: self.controller.meta.weekNumbers.count,
                        monthOffset: self.controller.meta.monthOffset,
                        days: self.controller.meta.days)
                        .modifier(self.calculateBodyHeightModifier(geometry: geometry))
                }
                
                Spacer()
                    .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
    private func calculateWeeknumWidth(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width * designBook.layout.weekNumberWidthCoef
    }
    
    private func calculateBodyHeightModifier(geometry: GeometryProxy) -> HeightModifier {
        let height = CGFloat(controller.meta.weekNumbers.count) * designBook.layout.weekDayHeight
        return HeightModifier(height: height)
    }
}

#if DEBUG
fileprivate struct SwiftUIView_Previews: PreviewProvider {
    private final class MockTraitEnvironment: NSObject, UITraitEnvironment {
        var traitCollection = UITraitCollection(horizontalSizeClass: .compact)
        
        func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        }
    }
    
    static var previews: some View {
        WidgetRootView(delegate: nil)
            .environmentObject(DesignBook(traitEnvironment: MockTraitEnvironment()))
            .previewLayout(PreviewLayout.fixed(width: 398, height: 450))
    }
}
#endif
