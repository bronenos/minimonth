//
//  CalendarWeekdayBar.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

struct CalendarWeekdayBar: View {
    @EnvironmentObject var designBook: DesignBook

    let captions: [String]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(self.captions, id: \.self) { caption in
                Text(caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(self.designBook.cached(usage: .captionColor))
            }
        }
    }
}
