//
//  UIScreenExtensions.swift
//  Hoster
//
//  Created by Stan Potemkin on 31.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit

enum ScreenKind: Int {
    case mini
    case regular
    case large
    case extraLarge
    
    func atLeast(_ kind: ScreenKind) -> Bool {
        return (rawValue >= kind.rawValue)
    }
}

extension UIScreen {
    var kind: ScreenKind {
        switch max(nativeBounds.width, nativeBounds.height) {
        case 2000... where UIDevice.current.userInterfaceIdiom == .pad: return .extraLarge
        case 2000...: return .extraLarge
        case 1900...: return .large
        case ...1200: return .mini
        default: return .regular
        }
    }
}
