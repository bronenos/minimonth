//
//  UIDeviceExtensions.swift
//  Hoster
//
//  Created by Stan Potemkin on 31.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasLargeScreen: Bool {
        switch userInterfaceIdiom {
        case .phone: return false
        case .pad: return true
        case .carPlay: return false
        case .tv: return true
        case .unspecified: return false
        @unknown default: return false
        }
    }
}
