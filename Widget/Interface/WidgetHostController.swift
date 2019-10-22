//
//  WidgetHostController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import NotificationCenter

protocol WidgetDelegate: class {
    func resize()
}

@objc(WidgetHostController) public final class WidgetHostController: UIViewController, NCWidgetProviding, WidgetDelegate {
    private var sizeCalculator: (CGSize) -> CGSize = { _ in .zero }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let designBook = DesignBook(traitEnvironment: self)
        let rootObject = WidgetRootView(delegate: self).environmentObject(designBook)
        
        let rootController = UIHostingController(rootView: rootObject)
        rootController.view.backgroundColor = nil
        sizeCalculator = rootController.sizeThatFits
        
        addChild(rootController)
        view.addSubview(rootController.view)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = nil
        children.first?.view.frame = view.bounds
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    public func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.newData)
    }
    
    public func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
    
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        preferredContentSize = CGSize(width: 398, height: min(maxSize.height, 391))
    }
    
    func resize() {
//        guard let rootView = children.first?.view else { return }
        preferredContentSize = CGSize(width: 398, height: 391)
    }
}
