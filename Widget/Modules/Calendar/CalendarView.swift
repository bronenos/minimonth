//
//  CalendarView.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

public enum CalendarPosition {
    case top
    case center
}

public struct CalendarView: View {
    @EnvironmentObject private var designBook: DesignBook
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @ObservedObject private var interactor: CalendarInteractor
    private let position: CalendarPosition
    
    public init(interactor: CalendarInteractor, position: CalendarPosition) {
        self.interactor = interactor
        self.position = position
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.obtainTopSpacer()
                
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
                        .clipped()

                    CalendarMonthView(
                        weeksNumber: self.interactor.meta.weekNumbers.count,
                        monthOffset: self.interactor.meta.monthOffset,
                        days: self.interactor.meta.days)
                        .modifier(self.calculateBodyHeightModifier(geometry: geometry))
                }

                Spacer()
                    .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity, alignment: .bottom)
            }
            .animation(self.interactor.shouldAnimate ? .linear(duration: 0.25) : nil)
        }
    }
    
    private func obtainTopSpacer() -> some View {
        switch position {
        case .top: return Spacer().frame(idealHeight: 0, maxHeight: 0, alignment: .top)
        case .center: return Spacer().frame(idealHeight: 0, maxHeight: .infinity, alignment: .top)
        }
    }
    
    private func calculateWeeknumWidth(geometry: GeometryProxy) -> CGFloat {
        if preferencesDriver.weeknumDisplay {
            return geometry.size.width * designBook.layout.weekNumberWidthCoef
        }
        else {
            return 0
        }
    }
    
    private func calculateBodyHeightModifier(geometry: GeometryProxy) -> HeightModifier {
        let height = CGFloat(interactor.meta.weekNumbers.count) * designBook.layout.weekDayHeight
        return HeightModifier(height: height)
    }
}

#if DEBUG
private final class MockTraitEnvironment: NSObject, UITraitEnvironment {
    var traitCollection = UITraitCollection(traitsFrom: [.init(horizontalSizeClass: .compact), .init(horizontalSizeClass: .compact)])
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { }
}

private let traitEnvironment = MockTraitEnvironment()
private let preferencesDriver = PreferencesDriver()
private let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: traitEnvironment)

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarViewWrapper(
            interactor: CalendarInteractor(style: .month, delegate: nil),
            position: .center,
            preferencesDriver: preferencesDriver,
            designBook: designBook)
            .environment(\.verticalSizeClass, .compact)
            .environment(\.horizontalSizeClass, .compact)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
#endif
