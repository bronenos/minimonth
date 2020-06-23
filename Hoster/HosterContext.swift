//
//  HosterContext.swift
//  Hoster
//
//  Created by Stan Potemkin on 26.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit
import Combine

struct HosterContextColorPickingMeta: Identifiable {
    let id: UUID
    let title: String
    let keyPath: PreferencesWritableKeyPath
}

final class HosterContext: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    private var pickedColors = [PreferencesWritableKeyPath: UIColor]()
    
    var colorPickingSheet: HosterContextColorPickingMeta?
    var colorPickingMeta: HosterContextColorPickingMeta? {
        didSet { objectWillChange.send() }
    }

    func presentColorPicker(title:String, keyPath: PreferencesWritableKeyPath) {
        if #available(iOS 14.0, *) {
            return
        }
        else {
            let meta = HosterContextColorPickingMeta(id: UUID(), title: title, keyPath: keyPath)
            
            if #available(iOS 14.0, *) {
                colorPickingMeta = meta
            }
            else {
                colorPickingMeta = meta
                colorPickingSheet = meta
            }
        }
    }
    
    func storeColor(_ color: UIColor, forKeyPath keyPath: PreferencesWritableKeyPath) {
        pickedColors[keyPath] = color
    }
    
    func retrieveColor(forKeyPath keyPath: PreferencesWritableKeyPath) -> UIColor? {
        return pickedColors[keyPath]
    }
    
    func dismissColorPicker() {
        colorPickingMeta = nil
        colorPickingSheet = nil
    }
}
