//
//  HosterColorPickerButton.swift
//  Hoster
//
//  Created by Stan Potemkin on 23.06.2020.
//  Copyright © 2020 bronenos. All rights reserved.
//

import UIKit
import SwiftUI

final class HosterColorPickerButton: NSObject, UIViewRepresentable {
    private let context: HosterContext
    private let title: String
    private let keyPath: PreferencesWritableKeyPath
    private var selectedColor: UIColor
    private let colorApplier: (PreferencesWritableKeyPath) -> Void
    
    init(context: HosterContext, title: String, keyPath: PreferencesWritableKeyPath, selectedColor: UIColor, colorApplier: @escaping (PreferencesWritableKeyPath) -> Void) {
        self.context = context
        self.title = title
        self.keyPath = keyPath
        self.selectedColor = selectedColor
        self.colorApplier = colorApplier
    }
    
    func makeUIView(context: UIViewRepresentableContext<HosterColorPickerButton>) -> UIView {
        return context.coordinator.view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<HosterColorPickerButton>) {
    }

    func makeCoordinator() -> UIViewController {
        if #available(iOS 14.0, *) {
            let viewController = NativePickerViewController(context: context, keyPath: keyPath, colorApplier: colorApplier)
            viewController.picker.selectedColor = selectedColor
            return viewController
        }
        else {
            return UIViewController()
        }
    }
}

@available(iOS 14.0, *)
fileprivate final class NativePickerViewController: UIViewController {
    private let context: HosterContext
    private let keyPath: PreferencesWritableKeyPath
    private let colorApplier: (PreferencesWritableKeyPath) -> Void
    
    let picker = UIColorWell()
    
    init(context: HosterContext, keyPath: PreferencesWritableKeyPath, colorApplier: @escaping (PreferencesWritableKeyPath) -> Void) {
        self.context = context
        self.keyPath = keyPath
        self.colorApplier = colorApplier
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        picker.removeObserver(
            self,
            forKeyPath: "selectedColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.supportsAlpha = true
        picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(picker)
        
        picker.addObserver(
            self,
            forKeyPath: "selectedColor",
            options: .new,
            context: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        picker.frame = view.bounds
    }
    
    override func observeValue(forKeyPath kvoKeyPath: String?, of kvoObject: Any?, change kvoChange: [NSKeyValueChangeKey : Any]?, context kvoContext: UnsafeMutableRawPointer?) {
        if (kvoObject as? UIColorWell) === picker {
            if let color = picker.selectedColor {
                context.storeColor(color, forKeyPath: keyPath)
                colorApplier(keyPath)
            }
            
            context.dismissColorPicker()
        }
        else {
            super.observeValue(forKeyPath: kvoKeyPath, of: kvoObject, change: kvoChange, context: kvoContext)
        }
    }
}
