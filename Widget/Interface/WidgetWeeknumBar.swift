//
//  WidgetWeeknumBar.swift
//  Today
//
//  Created by Stan Potemkin on 22.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct WidgetWeeknumBar: View {
    let weekNumbers: Range<Int>
    
    var body: some View {
        VStack {
            ForEach(weekNumbers, id: \.self) { number in
                Text("Hello World!")
            }
        }
    }
}
