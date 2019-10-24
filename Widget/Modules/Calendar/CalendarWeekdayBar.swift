//
//  CalendarWeekdayBar.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarWeekdayBar: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    
    let captions: [String]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(self.captions, id: \.self) { caption in
                Text(caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(self.preferencesDriver.weekdayColor))
            }
        }
    }
}
