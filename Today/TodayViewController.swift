//
//  TodayViewController.swift
//  Today
//
//  Created by Stan Potemkin on 9/12/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import UIKit
import NotificationCenter
import EventKit


let monthColorPrefKey = "monthColor"
let dayColorPrefKey = "dayColor"
let weekendColorPrefKey = "weekendColor"
let todayColorPrefKey = "todayColor"
let eventColorPrefKey = "eventColor"
let lastDatePrefKey = "lastDate"


@objc(TodayViewController) public class TodayViewController : UIViewController, NCWidgetProviding {
	let h2c = TodayViewController.hexToColor
	var monthColor: UIColor { return h2c(self.defs.object(forKey: monthColorPrefKey) as? String) }
	var dayColor: UIColor { return h2c(self.defs.object(forKey: dayColorPrefKey) as? String) }
	var weekendColor: UIColor { return h2c(self.defs.object(forKey: weekendColorPrefKey) as? String) }
	var todayColor: UIColor { return h2c(self.defs.object(forKey: todayColorPrefKey) as? String) }
	var eventColor: UIColor { return h2c(self.defs.object(forKey: eventColorPrefKey) as? String) }
	
    @IBOutlet var _effectView: UIView!
    
	@IBOutlet var _monthLabel: TodayMonthLabel!
	var monthLabel: TodayMonthLabel! { return _monthLabel }
	
	@IBOutlet var _prevMonthLabel: UILabel!
	var prevMonthLabel: UILabel! { return _prevMonthLabel }
	
	@IBOutlet var _nextMonthLabel: UILabel!
	var nextMonthLabel: UILabel! { return _nextMonthLabel }
	
	@IBOutlet var _weekdaysView: UIView!
	var weekdaysView: UIView! { return _weekdaysView }
	
	@IBOutlet var _weeksView: UIView!
	var weeksView: UIView! { return _weeksView }
	
	@IBOutlet var _weeksHeightConstraint: NSLayoutConstraint!
	var weeksHeightConstraint: NSLayoutConstraint! { return _weeksHeightConstraint }
	
	
	let calendar = Calendar.current
	let dateFormatter = DateFormatter()
	let defs = UserDefaults(suiteName: "group.V8NCXSZ3T7.me.bronenos.minimonth")!
	
	var dayToGenerate = Date()
	var daysOffset = 0
    var minimized = false
	
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
		TodayViewController.registerDefaultColors()
		self.setup()
	}
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		TodayViewController.registerDefaultColors()
		self.setup()
	}
	
	
	func setup() {
		self.dateFormatter.calendar = self.calendar
		self.dateFormatter.locale = Locale.current
		self.dateFormatter.dateStyle = .short
		self.dateFormatter.timeStyle = .none
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdates),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
	}
	
	
	class func registerDefaultColors() {
		let convert = TodayViewController.colorToHex
        let reg: [String : String]
        
        if #available(iOS 10, *) {
            reg = [
                monthColorPrefKey : convert(UIColor.black),
                dayColorPrefKey : convert(UIColor.black),
                weekendColorPrefKey : convert(UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)),
                todayColorPrefKey : convert(UIColor(red: 0, green: 0.5, blue: 0, alpha: 0.65)),
                eventColorPrefKey : convert(UIColor.brown),
            ]
        }
        else {
            reg = [
                monthColorPrefKey : convert(UIColor.white),
                dayColorPrefKey : convert(UIColor.white),
                weekendColorPrefKey : convert(UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)),
                todayColorPrefKey : convert(UIColor.green.withAlphaComponent(0.65)),
                eventColorPrefKey : convert(UIColor.yellow.withAlphaComponent(0.65)),
            ]
        }
        
		let defs = UserDefaults(suiteName: "group.V8NCXSZ3T7.me.bronenos.minimonth")!
		defs.register(defaults: reg)
		defs.synchronize()
	}
    
    public override func loadView() {
        view = UIView()
    }
	
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10, *) {
            if let widgetMode = extensionContext?.widgetActiveDisplayMode {
                minimized = (widgetMode == .compact)
            }
            else {
                minimized = false
            }
        }
        else {
            minimized = false
        }
        
        updateUI()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.generateWeekdays()
//        self.generateCalendar()
        
//        if #available(iOS 10, iOSApplicationExtension 10.0, *) {
//            self.updatePreferredContentSize()
//            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
//        }
    }
	
    override public var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI() {
//        if #available(iOS 12.0, iOSApplicationExtension 12.0, *) {
//            _effectView.isHidden = (traitCollection.userInterfaceStyle == .light)
//        }
//        else {
//            _effectView.isHidden = true
//        }
    }
    
    public func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        defs.synchronize()
        updateUI()
        completionHandler(.newData)

//		let newDate = self.dateStamp()
//
//		if let lastDate = self.defs.object(forKey: lastDatePrefKey) as? String {
//			if newDate == lastDate {
//				completionHandler(.newData)
//			}
//			else {
//				self.defs.set(newDate, forKey: lastDatePrefKey)
//				self.defs.synchronize()
//
//				completionHandler(.newData)
//			}
//		}
//		else {
//			self.defs.set(newDate, forKey: lastDatePrefKey)
//			self.defs.synchronize()
//
//			completionHandler(.newData)
//		}
    }
	
    public func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
    
    @available(iOS 10.0, iOSApplicationExtension 10.0, *)
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.minimized = (activeDisplayMode == .compact)
        self.generateCalendar()
        self.updatePreferredContentSize()
    }
    
    fileprivate func updatePreferredContentSize() {
        if self.minimized {
            let minimizedSize = CGSize(width: CGFloat.infinity, height: 20)
            self.preferredContentSize = minimizedSize
        }
        else {
            var maximizedSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            maximizedSize.height += 10
            
            self.preferredContentSize = maximizedSize
        }
    }
    
    
	class func colorToHex(_ color: UIColor!) -> String {
		if color != nil {
			var r: CGFloat = 0
			var g: CGFloat = 0
			var b: CGFloat = 0
			var a: CGFloat = 0
			color.getRed(&r, green: &g, blue: &b, alpha: &a)
			
			return "\(r) \(g) \(b) \(a)"
		}
		else {
			return "1 1 1 1"
		}
	}
	
	
	class func hexToColor(_ hex: String!) -> UIColor {
		if hex != nil {
			let colors = hex.components(separatedBy: " ")
			let r = CGFloat((colors[0] as NSString).floatValue)
			let g = CGFloat((colors[1] as NSString).floatValue)
			let b = CGFloat((colors[2] as NSString).floatValue)
			let a = CGFloat((colors[3] as NSString).floatValue)
			
			return UIColor(red: r, green: g, blue: b, alpha: a)
		}
		else {
			return UIColor.white
		}
	}
	
	
	func dateStamp() -> String {
		return self.dateFormatter.string(from: self.dayToGenerate)
	}
	
	
	func autoLayout(_ view: UIView, verticalMode: Bool) {
		var lastView: UIView!
		
		let views = view.superview!.subviews
		if views.count > 1 {
			lastView = views[views.count - 2]
		}
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		var c = NSLayoutConstraint(
			item: view, attribute: (verticalMode ? .leading : .top),
			relatedBy: .equal,
			toItem: view.superview, attribute: (verticalMode ? .leading : .top),
			multiplier: 1, constant: 0)
		view.superview!.addConstraint(c)
		
		c = NSLayoutConstraint(
			item: view, attribute: (verticalMode ? .trailing : .bottom),
			relatedBy: .equal,
			toItem: view.superview, attribute: (verticalMode ? .trailing : .bottom),
			multiplier: 1, constant: 0)
		view.superview!.addConstraint(c)
		
		if lastView == nil {
			c = NSLayoutConstraint(
				item: view, attribute: (verticalMode ? .top : .leading),
				relatedBy: .equal,
				toItem: view.superview, attribute: (verticalMode ? .top : .leading),
				multiplier: 1, constant: 0)
			view.superview!.addConstraint(c)
		}
		else {
			c = NSLayoutConstraint(
				item: view, attribute: (verticalMode ? .top : .left),
				relatedBy: .equal,
				toItem: lastView, attribute: (verticalMode ? .bottom : .right),
				multiplier: 1, constant: 0)
			view.superview!.addConstraint(c)
		}
	}
	
	
	func generateWeekdays() {
		var weekdayTitles = self.dateFormatter.shortWeekdaySymbols as [String]
		
		let wf = self.dateFormatter.calendar.firstWeekday
		let wc = weekdayTitles.count
		weekdayTitles = Array(weekdayTitles[(wf-1)..<wc]) + Array(weekdayTitles[0..<wf])
		
        let space = TodayWeekdayLabel(frame: CGRect.zero)
        self.weekdaysView.addSubview(space)
        
        self.autoLayout(space, verticalMode: false)
        
        let c = NSLayoutConstraint(
            item: space, attribute: .width,
            relatedBy: .greaterThanOrEqual,
            toItem: space.superview, attribute: .width,
            multiplier: 0.05, constant: 0)
        self.weekdaysView.addConstraint(c)
        
        var lastItem: TodayWeekdayLabel?
		for i in 1..<weekdayTitles.count {
			let label = TodayWeekdayLabel(frame: CGRect.zero)
			label.text = weekdayTitles[i - 1]
			label.textColor = self.monthColor.withAlphaComponent(0.6)
			self.weekdaysView.addSubview(label)
			
			self.autoLayout(label, verticalMode: false)
            lastItem = label
			
			let c = NSLayoutConstraint(
				item: label, attribute: .width,
				relatedBy: .equal,
				toItem: label.superview, attribute: .width,
                multiplier: 0.1290, constant: 0)
			self.weekdaysView.addConstraint(c)
		}
        
        if let item = lastItem {
            let c = NSLayoutConstraint(
                item: item, attribute: .trailing,
                relatedBy: .equal,
                toItem: lastItem?.superview, attribute: .trailing,
                multiplier: 1, constant: 0)
            self.weekdaysView.addConstraint(c)
        }

		self.weekdaysView.updateConstraintsIfNeeded()
		self.weekdaysView.layoutIfNeeded()
	}
	
	
	func generateWeek() -> UIView {
		let view = TodayWeekView()
		self.weeksView.addSubview(view)
		
		self.autoLayout(view, verticalMode: true)
		
		let c = NSLayoutConstraint(
			item: view, attribute: .height,
			relatedBy: .equal,
			toItem: nil, attribute: .notAnAttribute,
			multiplier: 1, constant: 25)
		self.weeksView.addConstraint(c)
		
		self.weeksView.updateConstraintsIfNeeded()
		self.weeksView.layoutIfNeeded()
		
		if let `$` = self.weeksView.subviews.last as? TodayWeekView {
			let f = `$`.frame
			self.weeksHeightConstraint.constant = f.maxY
			
			self.weeksView.updateConstraintsIfNeeded()
			self.weeksView.layoutIfNeeded()
		}
		
		return view
	}
	
	
    func generateDaysForWeek(_ weekView: UIView, weekBase: Int, dayBase: Int) {
        let weekLabel = TodayWeekLabel()
        weekLabel.textColor = self.monthColor.withAlphaComponent(0.6)
        weekLabel.tag = 100 + weekBase
        weekView.addSubview(weekLabel)
        
        self.autoLayout(weekLabel, verticalMode: false)
        
        let c = NSLayoutConstraint(
            item: weekLabel, attribute: .width,
            relatedBy: .greaterThanOrEqual,
            toItem: weekLabel.superview, attribute: .width,
            multiplier: 0.05, constant: 0)
        weekView.addConstraint(c)

        var lastItem: TodayDayLabel?
		for i in 1...7 {
			let dayView = TodayDayLabel()
			dayView.tag = dayBase + i
			dayView.textColor = (self.realWeekdayToUnitWeekday(i) <= 5 ? self.dayColor : self.weekendColor)
			weekView.addSubview(dayView)
			
			self.autoLayout(dayView, verticalMode: false)
            lastItem = dayView
			
			let c = NSLayoutConstraint(
				item: dayView, attribute: .width,
				relatedBy: .equal,
				toItem: dayView.superview, attribute: .width,
                multiplier: 0.1290,
				constant: 0)
			weekView.addConstraint(c)
		}
		
        if let item = lastItem {
            let c = NSLayoutConstraint(
                item: item, attribute: .trailing,
                relatedBy: .equal,
                toItem: lastItem?.superview, attribute: .trailing,
                multiplier: 1, constant: 0)
            weekView.addConstraint(c)
        }
        
		weekView.updateConstraintsIfNeeded()
		weekView.layoutIfNeeded()
	}
	
	
	func generateCalendar() {
		let calcDay = self.dayToGenerate
		
        let units: NSCalendar.Unit = [.year, .month, .weekday, .day, .weekOfMonth, .weekOfYear]
		let comps = (self.calendar as NSCalendar).components(units, from: calcDay)
		let todayComps = (self.calendar as NSCalendar).components(units, from: Date())
		
		let month = comps.month ?? 0
		let wday = self.unitWeekdayToRealWeekday(comps.weekday ?? 0)
		let day = comps.day ?? 0
		let totalWeeks = (self.calendar as NSCalendar).range(of: [.weekOfMonth], in: [.month], for: calcDay)
        let yearlyWeeks = (self.calendar as NSCalendar).range(of: [.weekOfYear], in: [.month], for: calcDay)
		let totalDays = (self.calendar as NSCalendar).range(of: [.day], in:[.month], for: calcDay)
		let swday = self.calculateStartWeekdayWithCurrentWeekday(wday, andDay: day)
        let week = todayComps.weekOfMonth ?? 0
		self.daysOffset = swday - 1
		
		let df = DateFormatter()
		df.locale = Locale.current
		self.monthLabel.textColor = self.monthColor
		self.monthLabel.text = df.standaloneMonthSymbols[month - 1]
		self.prevMonthLabel.textColor = self.monthColor
		self.nextMonthLabel.textColor = self.monthColor
		
		for s in self.weeksView.subviews {
			s.removeFromSuperview()
		}
        
        if self.minimized {
            let weekView = self.generateWeek()
            self.generateDaysForWeek(weekView, weekBase: week - 1, dayBase: (week - 1) * 7)
        }
        else {
            for i in 0..<totalWeeks.length {
                let weekView = self.generateWeek()
                self.generateDaysForWeek(weekView, weekBase: i, dayBase: i * 7)
            }
        }
        
        for i in (totalWeeks.lowerBound - 1 ..< totalWeeks.upperBound - 1) {
            let weekLabel = self.weeksView.viewWithTag(100 + i) as? TodayWeekLabel
            weekLabel?.text = "# \((yearlyWeeks.lowerBound - 1) + i + 1)"
        }
        
		for i in 1...totalDays.length {
			let dayLabel = self.weeksView.viewWithTag(self.daysOffset + i) as? TodayDayLabel
			dayLabel?.text = "\(i)"
		}
		
		if comps == todayComps {
			if let todayView = self.weeksView.viewWithTag(self.daysOffset + day) {
				var hlRect = todayView.bounds
				hlRect = hlRect.insetBy(dx: hlRect.size.width * 0.2, dy: hlRect.size.height * 0.1)
				
				let hlView = UIView(frame: hlRect)
				hlView.layer.borderColor = self.todayColor.cgColor
				hlView.layer.borderWidth = 1
				hlView.layer.cornerRadius = 10
				hlView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
				todayView.addSubview(hlView)
			}
		}
		
		self.requestEventDays()
	}
	
	
	func requestEventDays() {
		let store = EKEventStore()
		
		if EKEventStore.authorizationStatus(for: .event) == EKAuthorizationStatus.authorized {
			self.markEventDays(store)
		}
		else {
			store.requestAccess(to: .event, completion: {
				[weak self] (granted: Bool, _) in
                guard granted else { return }
                
                DispatchQueue.main.async {
                    self?.markEventDays(store)
                }
			})
		}
	}
	
	
	func markEventDays(_ store: EKEventStore) {
		let units: NSCalendar.Unit = [.year, .month, .day]
		let comps = (self.calendar as NSCalendar).components(units, from: self.dayToGenerate)
		
		var startComps = comps
		startComps.day = 1
		let startDate = self.calendar.date(from: startComps)!
		
		var endComps = comps
		endComps.day = 0
		endComps.month = (endComps.month ?? 0) + 1
		let endDate = self.calendar.date(from: endComps)!
		
		let pred = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
		let events = store.events(matching: pred)
		
        events.forEach { e in
            let c = (self.calendar as NSCalendar).components(units, from: e.startDate)
            if let eventView = self.weeksView.viewWithTag(self.daysOffset + (c.day ?? 0)) as? TodayDayLabel {
                eventView.pointColor = self.eventColor
            }
		}
	}
	
	
	func unitWeekdayToRealWeekday(_ weekday: Int) -> Int {
		let wf = self.calendar.firstWeekday
		let wc = self.calendar.weekdaySymbols.count
		
		var ret = weekday - (wf - 1)
		if ret < 1 {
			ret += wc
		}
		
		return ret
	}
	
	
	func realWeekdayToUnitWeekday(_ weekday: Int) -> Int {
		let wf = self.calendar.firstWeekday
		let wc = self.calendar.weekdaySymbols.count
		
		var ret = wc - weekday - (wf - 1)
		if ret < 1 {
			ret += wc
		}
		
		return ret
	}
	
	
	func calculateStartWeekdayWithCurrentWeekday(_ wday: Int, andDay day: Int) -> Int {
		let wc = self.calendar.weekdaySymbols.count
		
		var local_day = day
		var local_wday = wday
		
		while local_day > 1 {
			local_day -= 1
            local_wday = local_wday > 1 ? local_wday - 1 : wc
		}
		
		return local_wday
	}
	
    @objc private func handleUpdates() {
    }
	
	@IBAction func doSwitchMonth(_ rec: UIGestureRecognizer!) {
		let pt = rec.location(in: rec.view)
		let w = rec.view!.bounds.width
		
		let units: NSCalendar.Unit = [.year, .month, .day]
		var comps = (self.calendar as NSCalendar).components(units, from: self.dayToGenerate)
		
		if pt.x < (w * 0.3) {
			comps.month = (comps.month ?? 0) - 1
			self.dayToGenerate = self.calendar.date(from: comps)!
		}
		else if pt.x > (w * 0.7) {
            comps.month = (comps.month ?? 0) + 1
			self.dayToGenerate = self.calendar.date(from: comps)!
		}
		else {
			self.dayToGenerate = Date()
		}
		
		self.generateCalendar()
        self.updatePreferredContentSize()
	}
}
