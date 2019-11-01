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
        navigationController.edgesForExtendedLayout = []
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
    private let licenseLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        licenseLabel.text = "Color picking is powered by FlexColorPicker project"
        licenseLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        licenseLabel.textColor = UIColor.secondaryLabel
        licenseLabel.textAlignment = .center
        licenseLabel.numberOfLines = 0
        view.addSubview(licenseLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let licenseMargin = CGFloat(15)
        let licenseWidth = view.bounds.insetBy(dx: licenseMargin, dy: 0).width
        let licenseBounds = licenseLabel.textRect(
            forBounds: CGRect(
                origin: .zero,
                size: CGSize(width: licenseWidth, height: .infinity)
            ),
            limitedToNumberOfLines: 0
        )
        
        licenseLabel.frame = view.bounds
            .offsetBy(dx: 0, dy: -licenseMargin)
            .divided(atDistance: licenseBounds.height, from: .maxYEdge).slice
            .insetBy(dx: licenseMargin, dy: 0)
    }
}
