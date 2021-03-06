//
//  CalendarWeekdayBar.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct CalendarWeekdayBar: View {
    @EnvironmentObject var designBook: DesignBook

    let position: CalendarPosition
    let captions: [String]
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            ForEach(self.captions, id: \.self) { caption in
                Text(caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: position.shouldReduceFontSize ? 9 : 11, weight: .semibold))
                    .foregroundColor(self.designBook.cached(usage: .captionColor))
            }
            
            Spacer()
        }
    }
}
