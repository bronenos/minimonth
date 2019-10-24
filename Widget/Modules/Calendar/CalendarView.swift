//
//  CalendarView.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

public struct CalendarView: View {
    @EnvironmentObject private var designBook: DesignBook
    @ObservedObject private var interactor: CalendarInteractor
    
    init(interactor: CalendarInteractor) {
        self.interactor = interactor
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                convert(self.interactor.style) { style -> CalendarHeader in
                    switch style {
                    case .month:
                        return CalendarHeader(
                            title: self.interactor.meta.monthTitle,
                            year: self.interactor.meta.monthYear,
                            fastBackwardAction: self.interactor.navigateLongBackward,
                            backwardAction: self.interactor.navigateShortBackward,
                            titleAction: self.interactor.navigateNowadays,
                            forwardAction: self.interactor.navigateShortForward,
                            fastForwardAction: self.interactor.navigateLongForward)
                        
                    case .week:
                        return CalendarHeader(
                            title: self.interactor.meta.monthTitle,
                            year: self.interactor.meta.monthYear,
                            fastBackwardAction: nil,
                            backwardAction: self.interactor.navigateShortBackward,
                            titleAction: self.interactor.navigateNowadays,
                            forwardAction: self.interactor.navigateShortForward,
                            fastForwardAction: nil)
                    }
                }
                
                CalendarWeekdayBar(
                    captions: self.interactor.meta.weekdayTitles)
                    .frame(ownHeight: self.designBook.layout.weekHeaderHeight)
                    .padding(.leading, self.calculateWeeknumWidth(geometry: geometry))
                
                HStack(spacing: 0) {
                    CalendarWeeknumBar(
                        weekNumbers: self.interactor.meta.weekNumbers)
                        .frame(ownWidth: self.calculateWeeknumWidth(geometry: geometry))
                        .modifier(self.calculateBodyHeightModifier(geometry: geometry))

                    CalendarMonthView(
                        weeksNumber: self.interactor.meta.weekNumbers.count,
                        monthOffset: self.interactor.meta.monthOffset,
                        days: self.interactor.meta.days)
                        .modifier(self.calculateBodyHeightModifier(geometry: geometry))
                }
                
                Spacer()
                    .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity, alignment: .bottom)
            }
            .onAppear(perform: self.interactor.requestEvents)
            .animation(
                self.interactor.shouldAnimate(.styleChanged)
                    ? .linear(duration: 0.25)
                    : .none)
        }
    }
    
    private func calculateWeeknumWidth(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width * designBook.layout.weekNumberWidthCoef
    }
    
    private func calculateBodyHeightModifier(geometry: GeometryProxy) -> HeightModifier {
        let height = CGFloat(interactor.meta.weekNumbers.count) * designBook.layout.weekDayHeight
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
