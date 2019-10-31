//
//  CalendarRootController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import NotificationCenter

@objc(CalendarRootController) public final class CalendarRootController: UIViewController, NCWidgetProviding, CalendarDelegate {
    private var interactor: CalendarInteractor?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        rebuild(style: .month)
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
        case .compact: interactor?.toggle(style: .week)
        case .expanded: interactor?.toggle(style: .month)
        @unknown default: interactor?.toggle(style: .month)
        }
        
        resize()
    }
    
    private func rebuild(style: CalendarStyle) {
        children.first?.view.removeFromSuperview()
        children.first?.removeFromParent()
        
        let preferencesDriver = PreferencesDriver()
        let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: self)
        
        let rootInteractor = CalendarInteractor(style: style, delegate: self)
        let rootView = CalendarView(interactor: rootInteractor, position: .top)
            .environmentObject(preferencesDriver)
            .environmentObject(designBook)
        
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = nil
        
        interactor = rootInteractor
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
    
    private func calculateInnerHeight() -> CGFloat {
        guard let contentView = children.first?.view else { return 0 }
        let childFrames = contentView.subviews.map { $0.frame }
        return childFrames.reduce(CGRect.zero, { $0.union($1) }).height + 15
    }
    
    public func resize() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { [weak self] in
            let height = self?.calculateInnerHeight() ?? 0
            self?.preferredContentSize = CGSize(width: .infinity, height: height)
        }
    }
}
