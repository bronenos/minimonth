//
//  HeightModifier.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct HeightModifier: ViewModifier {
    let height: CGFloat
    
    func body(content: Content) -> some View {
        return content.frame(ownHeight: height)
    }
}
