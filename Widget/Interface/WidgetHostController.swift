//
//  WidgetHostController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import NotificationCenter

@objc(WidgetHostController) public final class WidgetHostController: UIHostingController<WidgetRootView>, NCWidgetProviding {
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let designBook = DesignBook()
        let rootView = WidgetRootView()
        _ = rootView.environmentObject(designBook)
        
        super.init(rootView: rootView)
        
        designBook.traitProvider = { [unowned self] in self }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
