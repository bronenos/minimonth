//
//  HosterColorPickerNativeSheet.swift
//  Hoster
//
//  Created by Stan Potemkin on 27.06.2020.
//  Copyright © 2020 bronenos. All rights reserved.
//

import UIKit
import SwiftUI

@available(iOS 14.0, *)
final class HosterColorPickerNativeSheet: NSObject, UIViewRepresentable, UIColorPickerViewControllerDelegate {
    private let context: HosterContext
    private let title: String
    private let keyPath: PreferencesWritableKeyPath
    private var selectedColor: UIColor
    
    init(context: HosterContext, title: String, keyPath: PreferencesWritableKeyPath, selectedColor: UIColor) {
        self.context = context
        self.title = title
        self.keyPath = keyPath
        self.selectedColor = selectedColor
    }
    
    func makeUIView(context: UIViewRepresentableContext<HosterColorPickerNativeSheet>) -> UIView {
        return context.coordinator.view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<HosterColorPickerNativeSheet>) {
    }

    func makeCoordinator() -> UIViewController {
        let viewController = UIColorPickerViewController()
        viewController.navigationItem.title = title
        viewController.edgesForExtendedLayout = []
        viewController.view.backgroundColor = UIColor.systemGroupedBackground
        viewController.selectedColor = selectedColor
        viewController.supportsAlpha = false
        viewController.delegate = self
        return viewController
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        context.storeColor(selectedColor, forKeyPath: keyPath)
        context.dismissColorPicker()
    }
}
