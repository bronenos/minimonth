//
//  HosterRootController.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI

extension UIWindowScene: UITraitEnvironment {
    public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    }
}

@objc(HosterRootController) public final class HosterRootController: UIViewController, HosterViewDelegate {
    private let windowScene: UIWindowScene
    
    private var designBook: DesignBook?
    
    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        rebuild()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        children.first?.view.frame = view.bounds
    }
    
    public override var preferredContentSize: CGSize {
        didSet { children.first?.preferredContentSize = preferredContentSize }
    }
    
    private func rebuild() {
        children.first?.view.removeFromSuperview()
        children.first?.removeFromParent()
        
        let preferencesDriver = PreferencesDriver()
        let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: windowScene)
        let context = HosterContext()
        self.designBook = designBook

        let rootView = HosterView(windowScene: windowScene, delegate: self)
            .environmentObject(preferencesDriver)
            .environmentObject(designBook)
            .environmentObject(context)

        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = UIColor.clear

        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
    
    func didRequestStyleUpdate(_ style: ColorScheme?) {
        switch style {
        case .light?: overrideUserInterfaceStyle = .light
        case .dark?: overrideUserInterfaceStyle = .dark
        default: overrideUserInterfaceStyle = .unspecified
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        designBook?.objectWillChange.send()
    }
}
