//
//  EventService.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import Combine
import EventKit

protocol IEventService: class {
    func subscribe(eventsCallback: @escaping ([EKEvent]) -> Void) -> AnyCancellable
    func request(anchorDate: Date)
}

final class EventService: IEventService, ObservableObject {
    @Published var anchoredEvents: [EKEvent] = []
    
    private let store = EKEventStore()
    private let calendar: Calendar
    private var anchorDate: Date
    
    init(calendar: Calendar, anchorDate: Date) {
        self.calendar = calendar
        self.anchorDate = anchorDate
    }
    
    func subscribe(eventsCallback: @escaping ([EKEvent]) -> Void) -> AnyCancellable {
        return $anchoredEvents.sink(receiveValue: eventsCallback)
    }
    
    func request(anchorDate: Date) {
        self.anchorDate = anchorDate
        
        if hasAccess {
            let units: Set<Calendar.Component> = [.year, .month, .day]
            let comps = calendar.dateComponents(units, from: anchorDate)
            
            var startComps = comps
            startComps.day = 1
            let startDate = calendar.date(from: startComps) ?? Date()
            
            var endComps = comps
            endComps.day = 0
            endComps.month = (endComps.month ?? 0) + 1
            let endDate = calendar.date(from: endComps) ?? Date()
            
            let pred = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let events = store.events(matching: pred)
            anchoredEvents = events
        }
        else {
            store.requestAccess(to: .event) { [weak self] granted, _ in
                guard granted else { return }
                DispatchQueue.main.async { self?.request(anchorDate: anchorDate) }
            }
        }
    }
    
    private var hasAccess: Bool {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized: return true
        case .notDetermined: return false
        case .restricted: return false
        case .denied: return false
        @unknown default: return false
        }
    }
}

