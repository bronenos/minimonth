//
//  WidgetWeekdayBar.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct WidgetWeekdayBar: View {
    let captions: [String]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(self.captions, id: \.self, content: WidgetWeekdayCaption.init)
        }
    }
}
