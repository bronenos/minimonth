//
//  HosterRootController.swift
//  Hoster
//
//  Created by Stan Potemkin on 25.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import Shared

@objc(HosterRootController) public final class HosterRootController: UIViewController {
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
        let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: self)
//        let interactor = CalendarInteractor(style: style, delegate: self)
//        let calendarView = CalendarView(interactor: interactor).environmentObject(designBook)
//        self.interactor = interactor

        let rootView = HosterView()
            .environmentObject(preferencesDriver)
            .environmentObject(designBook)

        let hostingController = UIHostingController(rootView: rootView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
}
