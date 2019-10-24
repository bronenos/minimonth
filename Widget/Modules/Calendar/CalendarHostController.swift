//
//  CalendarHostController.swift
//  Today
//
//  Created by Stan Potemkin on 21.10.2019.
//  Copyright © 2019 bronenos. All rights reserved.
//

import SwiftUI
import NotificationCenter

@objc(CalendarHostController) public final class CalendarHostController: UIViewController, NCWidgetProviding, CalendarDelegate {
    private var interactor: CalendarInteractor?
    
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
        case .compact: interactor?.toggle(style: .week)
        case .expanded: interactor?.toggle(style: .month)
        @unknown default: interactor?.toggle(style: .month)
        }
        
        resize()
    }
    
    private func build(style: CalendarStyle) {
        let designBook = DesignBook(traitEnvironment: self)
        let interactor = CalendarInteractor(style: style, delegate: self)
        let calendarView = CalendarView(interactor: interactor).environmentObject(designBook)
        self.interactor = interactor

        let hostingController = UIHostingController(rootView: calendarView)
        hostingController.view.backgroundColor = nil
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
    
    private func calculateInnerHeight() -> CGFloat {
        guard let contentView = children.first?.view else { return 0 }
        let childFrames = contentView.subviews.map { $0.frame }
        return childFrames.reduce(CGRect.zero, { $0.union($1) }).height + 15
    }
    
    func resize() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) { [weak self] in
            let height = self?.calculateInnerHeight() ?? 0
            self?.preferredContentSize = CGSize(width: .infinity, height: height)
        }
    }
}
