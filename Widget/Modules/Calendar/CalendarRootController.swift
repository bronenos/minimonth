//
//  CalendarRootController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import NotificationCenter

@objc(CalendarRootController) public final class CalendarRootController: UIViewController, NCWidgetProviding {
    private var interactor: CalendarInteractor?
    
    private var hostingLayerObserver: NSKeyValueObservation?
    private weak var autosizingTimer: Timer?
    
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
    }
    
    private func rebuild(style: CalendarStyle) {
        children.first?.view.removeFromSuperview()
        children.first?.removeFromParent()
        
        let preferencesDriver = PreferencesDriver()
        let designBook = DesignBook(preferencesDriver: preferencesDriver, traitEnvironment: self)
        
        let rootInteractor = CalendarInteractor(
            style: style,
            shortest: false,
            renderEvents: true)
        
        let rootView = CalendarView(interactor: rootInteractor, position: .today, background: Color.clear)
            .environmentObject(preferencesDriver)
            .environmentObject(designBook)
            .environment(\.adjustments, designBook.adjustments(position: .today, size: .zero))
        
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = nil
        
        interactor = rootInteractor
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingLayerObserver = hostingController.view.layer.observe(\.sublayers) { [weak self] layer, change in
            self?.requestDelayAutosizing()
        }
    }
    
    private func calculateInnerHeight() -> CGFloat {
        guard let contentView = children.first?.view else { return 0 }
        let subviews = contentView.subviews
        let childTopMost = subviews.map({ $0.frame.minY }).min() ?? 0
        let childBottomMost = subviews.map({ $0.frame.maxY }).max() ?? 0
        return (childBottomMost - childTopMost) + 25
    }
    
    private func requestDelayAutosizing() {
        cancelDelayedAutosizing()
        autosizingTimer = Timer.scheduledTimer(
            timeInterval: 0.05,
            target: self,
            selector: #selector(handleAutosizingTimer),
            userInfo: nil,
            repeats: false
        )
    }
    
    private func cancelDelayedAutosizing() {
        autosizingTimer?.invalidate()
    }
    
    @objc private func handleAutosizingTimer() {
        let height = calculateInnerHeight()
        preferredContentSize = CGSize(width: .infinity, height: height)
    }
}
