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
    let spaceCoef: CGFloat
    let captionCoef: CGFloat
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                EmptyView()
                    .frame(
                        width: geometry.size.width.multiply(by: self.spaceCoef),
                        height: geometry.size.height.multiply(by: 1.0),
                        alignment: .center)
                
                ForEach(self.captions, id: \.self) { caption in
                    WidgetWeekdayCaption(caption: caption)
                        .frame(
                            width: geometry.size.width.multiply(by: self.captionCoef),
                            height: geometry.size.height.multiply(by: 1.0),
                            alignment: .center)
                }
            }
        }
    }
}
