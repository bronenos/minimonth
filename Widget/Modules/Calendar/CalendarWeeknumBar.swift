//
//  CalendarWeeknumBar.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarWeeknumBar: View {
    @EnvironmentObject var designBook: DesignBook

    let weekNumbers: Range<Int>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(weekNumbers, id: \.self) { number in
                Text("# \(number)")
                    .frame(maxHeight: .infinity, alignment: .center)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(self.designBook.cached(usage: .captionColor))
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.trailing, 7)
        .padding(.leading, 5)
    }
}
