//
//  WidgetRootView.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, iOSApplicationExtension 13.0.0, *)
public struct WidgetRootView: View {
    @ObservedObject var meta = WidgetMeta()
    
    public var body: some View {
        VStack {
            WidgetMonthHeader()
        }
    }
}
