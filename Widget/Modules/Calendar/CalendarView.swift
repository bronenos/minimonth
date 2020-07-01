//
//  CalendarView.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

public enum CalendarPosition {
    case host
    case today
    case small
    case medium
}

public struct CalendarView<Background: View>: View {
    @EnvironmentObject private var designBook: DesignBook
    @EnvironmentObject private var preferencesDriver: PreferencesDriver
    @ObservedObject private var interactor: CalendarInteractor
    private let position: CalendarPosition
    private let background: Background
    
    public init(interactor: CalendarInteractor, position: CalendarPosition, background: Background) {
        self.interactor = interactor
        self.position = position
        self.background = background
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.obtainTopSpacer()
                
                convert(self.interactor.style) { style -> CalendarHeader in
                    switch style {
                    case .month where position.shouldDisplayControls:
                        return CalendarHeader(
                            position: position,
                            weekNumber: self.interactor.meta.weekNumber,
                            title: self.interactor.meta.monthTitle,
                            year: self.interactor.meta.monthYear,
                            fastBackwardAction: self.interactor.navigateLongBackward,
                            backwardAction: self.interactor.navigateShortBackward,
                            titleAction: self.interactor.navigateNowadays,
                            forwardAction: self.interactor.navigateShortForward,
                            fastForwardAction: self.interactor.navigateLongForward)
                        
                    case .week where position.shouldDisplayControls:
                        return CalendarHeader(
                            position: position,
                            weekNumber: self.interactor.meta.weekNumber,
                            title: self.interactor.meta.monthTitle,
                            year: self.interactor.meta.monthYear,
                            fastBackwardAction: nil,
                            backwardAction: self.interactor.navigateShortBackward,
                            titleAction: self.interactor.navigateNowadays,
                            forwardAction: self.interactor.navigateShortForward,
                            fastForwardAction: nil)
                        
                    default:
                        return CalendarHeader(
                            position: position,
                            weekNumber: self.interactor.meta.weekNumber,
                            title: self.interactor.meta.fullTitle,
                            year: nil,
                            fastBackwardAction: nil,
                            backwardAction: nil,
                            titleAction: self.interactor.navigateNowadays,
                            forwardAction: nil,
                            fastForwardAction: nil)
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.035)

                CalendarWeekdayBar(
                    position: position,
                    captions: self.interactor.meta.weekdayTitles)
                    .frame(ownHeight: self.designBook.layout(position: position).weekHeaderHeight)
                    .padding(.leading, position.shouldDisplayWeekNumbers ? self.calculateWeeknumWidth(geometry: geometry) : 0)
                    .padding(.horizontal, position.shouldDisplayWeekNumbers ? 0 : -2)

                if position.shouldPlaceInMiddle {
                    Spacer()
                        .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity, alignment: .top)
                }
                
                HStack(spacing: 0) {
                    if position.shouldDisplayWeekNumbers {
                        CalendarWeeknumBar(
                            weekNumbers: self.interactor.meta.weekNumbers)
                            .frame(ownWidth: self.calculateWeeknumWidth(geometry: geometry), alignment: .leading)
                            .modifier(self.calculateBodyHeightModifier(geometry: geometry))
                            .clipped()
                    }

                    CalendarMonthView(
                        position: position,
                        weeksNumber: self.interactor.meta.weekNumbers.count,
                        monthOffset: self.interactor.meta.monthOffset,
                        days: self.interactor.meta.days)
                        .modifier(self.calculateBodyHeightModifier(geometry: geometry))
                        .padding(.horizontal, geometry.size.width * 0.01)
                }

                Spacer()
                    .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity, alignment: .bottom)
                
                if position.shouldReduceFontSize {
                    Spacer()
                        .frame(minHeight: 5, idealHeight: 5, maxHeight: 5, alignment: .bottom)
                }
            }
            .padding(.horizontal, position.shouldMinimizeEdges ? 5 : 10)
        }
        .background(background)
    }
    
    private func obtainTopSpacer() -> some View {
        switch position {
        case .host: return Spacer().frame(idealHeight: 0, maxHeight: .infinity, alignment: .top)
        case .today: return Spacer().frame(idealHeight: 0, maxHeight: 0, alignment: .top)
        case .small: return Spacer().frame(idealHeight: 7, maxHeight: 7)
        case .medium: return Spacer().frame(idealHeight: 7, maxHeight: 7)
        }
    }
    
    private func calculateWeeknumWidth(geometry: GeometryProxy) -> CGFloat {
        if preferencesDriver.shouldDisplayWeekNumbers {
            return geometry.size.width * designBook.layout(position: position).weekNumberWidthCoef
        }
        else {
            return 0
        }
    }
    
    private func calculateBodyHeightModifier(geometry: GeometryProxy) -> HeightModifier {
        let height = CGFloat(interactor.meta.weekNumbers.count) * designBook.layout(position: position).weekDayHeight
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
            interactor: CalendarInteractor(
                style: .month,
                shortest: false),
            position: .host,
            preferencesDriver: preferencesDriver,
            designBook: designBook)
            .environment(\.verticalSizeClass, .compact)
            .environment(\.horizontalSizeClass, .compact)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
#endif

extension CalendarPosition {
    var shouldPlaceInMiddle: Bool {
        switch self {
        case .host: return false
        case .today: return false
        case .small: return true
        case .medium: return true
        }
    }
    
    var shouldDisplayControls: Bool {
        switch self {
        case .host: return true
        case .today: return true
        case .small: return false
        case .medium: return false
        }
    }
    
    var shouldDisplayIndicator: Bool {
        switch self {
        case .host: return true
        case .today: return true
        case .small: return true
        case .medium: return true
        }
    }
    
    var shouldDisplayIndicatorAtBottom: Bool {
        switch self {
        case .host: return true
        case .today: return true
        case .small: return true
        case .medium: return false
        }
    }
    
    var shouldDisplayWeekNumbers: Bool {
        switch self {
        case .host: return true
        case .today: return true
        case .small: return false
        case .medium: return true
        }
    }
    
    var shouldMinimizeEdges: Bool {
        switch self {
        case .host: return false
        case .today: return false
        case .small: return true
        case .medium: return false
        }
    }
    
    var shouldReduceFontSize: Bool {
        switch self {
        case .host: return false
        case .today: return false
        case .small: return true
        case .medium: return false
        }
    }
    
    var shouldDisplayShortestCaptions: Bool {
        switch self {
        case .host: return false
        case .today: return false
        case .small: return true
        case .medium: return false
        }
    }
}
