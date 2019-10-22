//
//  WidgetHostController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import NotificationCenter

@objc(WidgetHostController) public final class WidgetHostController: UIViewController, NCWidgetProviding {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let designBook = DesignBook(traitEnvironment: self)
        let rootView = WidgetRootView().environmentObject(designBook)
        
        let rootController = UIHostingController(rootView: rootView)
        rootController.view.backgroundColor = nil
        
        addChild(rootController)
        view.addSubview(rootController.view)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let hostingController = children.first {
            hostingController.view.frame = view.bounds
        }
    }
    
    public override var preferredContentSize: CGSize {
        get { children.first?.preferredContentSize ?? .zero }
        set { children.first?.preferredContentSize = newValue }
    }
    
    public func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        view.backgroundColor = nil
        completionHandler(.newData)
    }
    
    public func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
    
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    }
}
