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
    
    var colorPickingMeta: HosterContextColorPickingMeta? {
        didSet { objectWillChange.send() }
    }

    func presentColorPicker(title:String, keyPath: PreferencesWritableKeyPath) {
        colorPickingMeta = HosterContextColorPickingMeta(id: UUID(), title: title, keyPath: keyPath)
    }
    
    func storeColor(_ color: UIColor, forKeyPath keyPath: PreferencesWritableKeyPath) {
        pickedColors[keyPath] = color
    }
    
    func retrieveColor(forKeyPath keyPath: PreferencesWritableKeyPath) -> UIColor? {
        return pickedColors[keyPath]
    }
    
    func dismissColorPicker() {
        colorPickingMeta = nil
    }
}
