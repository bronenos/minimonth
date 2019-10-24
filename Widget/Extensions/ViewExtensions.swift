//
//  ViewExtensions.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

extension View {
    func frame(ownWidth: CGFloat? = nil, ownHeight: CGFloat? = nil) -> some View {
        return frame(
            minWidth: ownWidth,
            idealWidth: ownWidth,
            maxWidth: ownWidth,
            minHeight: ownHeight,
            idealHeight: ownHeight,
            maxHeight: ownHeight,
            alignment: .center
        )
    }
    
    func frame(ownSide: CGFloat) -> some View {
        return frame(ownWidth: ownSide, ownHeight: ownSide)
    }
}
