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
    private var controller: WidgetController?
    private var sizeCalculator: (CGSize) -> CGSize = { _ in .zero }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = nil
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        build(style: .month)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        children.first?.view.frame = view.bounds
    }
    
    public override var preferredContentSize: CGSize {
        didSet { children.first?.preferredContentSize = preferredContentSize }
    }
    
    public func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(.newData)
    }
    
    public func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
    
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact: controller?.toggle(style: .week)
        case .expanded: controller?.toggle(style: .month)
        @unknown default: controller?.toggle(style: .month)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) { [weak self] in
            let height = self?.calculateInnerHeight() ?? 0
            self?.preferredContentSize = CGSize(width: .infinity, height: height)
        }
    }
    
    private func build(style: WidgetController.Style) {
        let designBook = DesignBook(traitEnvironment: self)
        let rootController = WidgetController(style: style, delegate: self)
        let rootObject = WidgetRootView(controller: rootController).environmentObject(designBook)
        
        let hostingController = UIHostingController(rootView: rootObject)
        hostingController.view.backgroundColor = nil
        
        controller = rootController
        sizeCalculator = hostingController.sizeThatFits
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
    
    private func calculateInnerHeight() -> CGFloat {
        guard let contentView = children.first?.view else { return 0 }
        let childFrames = contentView.subviews.map { $0.frame }
        return childFrames.reduce(CGRect.zero, { $0.union($1) }).height + 15
    }
    
    func resize() {
//        calculateInnerHeight()
    }
}
