//
//  CalendarRootController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import NotificationCenter

@objc(CalendarRootController) public final class CalendarRootController: UIViewController, NCWidgetProviding, CalendarDelegate, CALayerDelegate {
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
//        hostingController.view.layer.delegate = self

        interactor = rootInteractor
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
    
    private func calculateInnerHeight() -> CGFloat {
        guard let contentView = children.first?.view else { return 0 }
        let subviews = contentView.subviews
        let childFrames = subviews.map { $0.frame }
        return childFrames.reduce(CGRect.zero, { $0.union($1) }).height + 15
    }
    
    public func resize() {
        //        let height = calculateInnerHeight() ?? 0
        //        preferredContentSize = CGSize(width: .infinity, height: height)
    }
    
    public func _resize() {
        let height = calculateInnerHeight()
        preferredContentSize = CGSize(width: .infinity, height: height)
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(CALayerDelegate.layoutSublayers(of:)) {
            DispatchQueue.main.async { [weak self] in
                self?._resize()
            }
            
            return false
        }
        else {
            return super.responds(to: aSelector)
        }
    }
    
    @objc(layoutSublayersOfLayer:) public func layoutSublayers(of layer: CALayer) {
        
    }
}
