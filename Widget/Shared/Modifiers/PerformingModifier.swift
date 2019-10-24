//
//  PerformingModifier.swift
//  Today
//
//  Created by Stan Potemkin on 23.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

struct PerformingModifier: ViewModifier {
    let block: () -> Void
    
    func body(content: Content) -> some View {
        let b = block
        defer { DispatchQueue.main.async(execute: b) }
        
        return content
    }
}
