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
        Text("\(day.number)")
    }
}
