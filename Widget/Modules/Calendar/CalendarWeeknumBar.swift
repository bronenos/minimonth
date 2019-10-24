//
//  CalendarWeeknumBar.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarWeeknumBar: View {
    @EnvironmentObject var preferencesDriver: PreferencesDriver
    
    let weekNumbers: Range<Int>
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(weekNumbers, id: \.self) { number in
                Text("# \(number)")
                    .frame(maxHeight: .infinity, alignment: .center)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(self.preferencesDriver.weeknumColor))
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}
