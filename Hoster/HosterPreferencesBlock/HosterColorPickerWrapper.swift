//
//  HosterColorPickerWrapper.swift
//  Hoster
//
//  Created by Stan Potemkin on 26.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import UIKit
import SwiftUI

final class HosterColorPickerWrapper: NSObject, UIViewRepresentable, ColorPickerDelegate {
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
    
    func makeUIView(context: UIViewRepresentableContext<HosterColorPickerWrapper>) -> UIView {
        let navigationController = UINavigationController(rootViewController: context.coordinator)
        return navigationController.view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<HosterColorPickerWrapper>) {
    }

    func makeCoordinator() -> UIViewController {
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(handleDone)
        )
        
        let viewController = CustomPickerViewController()
        viewController.navigationItem.title = title
        viewController.navigationItem.rightBarButtonItem = doneButton
        viewController.edgesForExtendedLayout = []
        viewController.view.backgroundColor = UIColor.systemGroupedBackground
        viewController.colorPreview.isHidden = true
        viewController.colorPalette.layer.cornerRadius = 10
        viewController.colorPalette.layer.masksToBounds = true
        viewController.selectedColor = selectedColor
        viewController.useRadialPalette = false
        viewController.delegate = self
        return viewController
    }
    
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor color: UIColor, usingControl: ColorControl) {
        selectedColor = color
    }
    
    func colorPicker(_ colorPicker: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
    }
    
    @objc private func handleDone() {
        context.storeColor(selectedColor, forKeyPath: keyPath)
        context.dismissColorPicker()
    }
}

fileprivate final class CustomPickerViewController: DefaultColorPickerViewController {
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        var brightnessFrame = brightnessSlider.frame
//        let brightnessDelta = view.bounds.maxX - brightnessFrame.maxX
//        brightnessFrame.size.width += brightnessDelta
//        brightnessFrame.origin.x -= brightnessDelta
//        brightnessSlider.frame = brightnessFrame
//    }
}
