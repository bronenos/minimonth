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


class TodayViewController : UIViewController {
	let h2c = TodayViewController.hexToColor
	var monthColor: UIColor { return h2c(self.defs.objectForKey(monthColorPrefKey) as NSString) }
	var dayColor: UIColor { return h2c(self.defs.objectForKey(dayColorPrefKey) as NSString) }
	var weekendColor: UIColor { return h2c(self.defs.objectForKey(weekendColorPrefKey) as NSString) }
	var todayColor: UIColor { return h2c(self.defs.objectForKey(todayColorPrefKey) as NSString) }
	var eventColor: UIColor { return h2c(self.defs.objectForKey(eventColorPrefKey) as NSString) }
	
	
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
	
	
	let calendar = NSCalendar.currentCalendar()
	let dateFormatter = NSDateFormatter()
	let defs = NSUserDefaults(suiteName: "group.me.bronenos.minimonth")!
	
	var dayToGenerate = NSDate()
	var daysOffset = 0
	
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nil, bundle: nil)
		TodayViewController.registerDefaultColors()
		self.setup()
	}
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		TodayViewController.registerDefaultColors()
		self.setup()
	}
	
	
	func setup() {
		self.dateFormatter.calendar = self.calendar
		self.dateFormatter.locale = NSLocale.currentLocale()
		self.dateFormatter.dateStyle = .ShortStyle
		self.dateFormatter.timeStyle = .NoStyle
	}
	
	
	class func registerDefaultColors() {
		let convert = TodayViewController.colorToHex
		let reg = [
			monthColorPrefKey : convert(UIColor.whiteColor()),
			dayColorPrefKey : convert(UIColor.whiteColor()),
			weekendColorPrefKey : convert(UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)),
			todayColorPrefKey : convert(UIColor.greenColor().colorWithAlphaComponent(0.65)),
			eventColorPrefKey : convert(UIColor.yellowColor().colorWithAlphaComponent(0.65)),
		]
		
		let defs = NSUserDefaults(suiteName: "group.me.bronenos.minimonth")!
		defs.registerDefaults(reg)
		defs.synchronize()
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.generateWeekdays()
		self.generateCalendar()
    }
	
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
		let newDate = self.dateStamp()
		
		if let lastDate = self.defs.objectForKey(lastDatePrefKey) as? String {
			if newDate == lastDate {
				completionHandler(.NoData)
			}
			else {
				self.defs.setObject(newDate, forKey: lastDatePrefKey)
				self.defs.synchronize()
				
				completionHandler(.NewData)
			}
		}
		else {
			self.defs.setObject(newDate, forKey: lastDatePrefKey)
			self.defs.synchronize()
			
			completionHandler(.NewData)
		}
    }
	
	
	class func colorToHex(color: UIColor!) -> String {
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
	
	
	class func hexToColor(hex: String!) -> UIColor {
		if hex != nil {
			let colors = (hex as NSString).componentsSeparatedByString(" ") as [NSString]
			let r = CGFloat((colors[0] as NSString).floatValue)
			let g = CGFloat((colors[1] as NSString).floatValue)
			let b = CGFloat((colors[2] as NSString).floatValue)
			let a = CGFloat((colors[3] as NSString).floatValue)
			
			return UIColor(red: r, green: g, blue: b, alpha: a)
		}
		else {
			return UIColor.whiteColor()
		}
	}
	
	
	func dateStamp() -> String {
		return self.dateFormatter.stringFromDate(self.dayToGenerate)
	}
	
	
	func autoLayout(view: UIView, verticalMode: Bool) {
		var lastView: UIView!
		
		let views = view.superview!.subviews
		if views.count > 1 {
			lastView = views[views.count - 2] as? UIView
		}
		
		view.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		var c = NSLayoutConstraint(
			item: view, attribute: (verticalMode ? .Leading : .Top),
			relatedBy: .Equal,
			toItem: view.superview, attribute: (verticalMode ? .Leading : .Top),
			multiplier: 1, constant: 0)
		view.superview!.addConstraint(c)
		
		c = NSLayoutConstraint(
			item: view, attribute: (verticalMode ? .Trailing : .Bottom),
			relatedBy: .Equal,
			toItem: view.superview, attribute: (verticalMode ? .Trailing : .Bottom),
			multiplier: 1, constant: 0)
		view.superview!.addConstraint(c)
		
		if lastView == nil {
			c = NSLayoutConstraint(
				item: view, attribute: (verticalMode ? .Top : .Leading),
				relatedBy: .Equal,
				toItem: view.superview, attribute: (verticalMode ? .Top : .Leading),
				multiplier: 1, constant: 0)
			view.superview!.addConstraint(c)
		}
		else {
			c = NSLayoutConstraint(
				item: view, attribute: (verticalMode ? .Top : .Left),
				relatedBy: .Equal,
				toItem: lastView, attribute: (verticalMode ? .Bottom : .Right),
				multiplier: 1, constant: 0)
			view.superview!.addConstraint(c)
		}
	}
	
	
	func generateWeekdays() {
		var weekdayTitles = self.dateFormatter.shortWeekdaySymbols as [String]
		
		let wf = self.dateFormatter.calendar.firstWeekday
		let wc = weekdayTitles.count
		weekdayTitles = Array(weekdayTitles[(wf-1)..<wc]) + Array(weekdayTitles[0..<wf])
		
		for i in 1..<weekdayTitles.count {
			var label = TodayWeekdayLabel(frame: CGRectZero)
			label.text = weekdayTitles[i - 1]
			label.textColor = self.monthColor.colorWithAlphaComponent(0.6)
			self.weekdaysView.addSubview(label)
			
			self.autoLayout(label, verticalMode: false)
			
			var c = NSLayoutConstraint(
				item: label, attribute: .Width,
				relatedBy: .Equal,
				toItem: label.superview, attribute: .Width,
				multiplier: 0.1428, constant: 0)
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
			item: view, attribute: .Height,
			relatedBy: .Equal,
			toItem: nil, attribute: .NotAnAttribute,
			multiplier: 1, constant: 25)
		self.weeksView.addConstraint(c)
		
		self.weeksView.updateConstraintsIfNeeded()
		self.weeksView.layoutIfNeeded()
		
		if let $ = self.weeksView.subviews.last as? TodayWeekView {
			var f = $.frame
			self.weeksHeightConstraint.constant = CGRectGetMaxY(f)
			
			self.weeksView.updateConstraintsIfNeeded()
			self.weeksView.layoutIfNeeded()
		}
		
		return view
	}
	
	
	func generateDaysForWeek(weekView: UIView, baseTag: Int) {
		for i in 1...7 {
			let dayView = TodayDayLabel()
			dayView.tag = baseTag + i
			dayView.textColor = (self.realWeekdayToUnitWeekday(i) <= 5 ? self.dayColor : self.weekendColor)
			weekView.addSubview(dayView)
			
			self.autoLayout(dayView, verticalMode: false)
			
			let c = NSLayoutConstraint(
				item: dayView, attribute: .Width,
				relatedBy: .Equal,
				toItem: dayView.superview, attribute: .Width,
				multiplier: 1.0 / 7.0,
				constant: 0)
			weekView.addConstraint(c)
		}
		
		weekView.updateConstraintsIfNeeded()
		weekView.layoutIfNeeded()
	}
	
	
	func generateCalendar() {
		let calcDay = self.dayToGenerate
		
		let units: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .WeekdayCalendarUnit | .DayCalendarUnit
		var comps = self.calendar.components(units, fromDate: calcDay)
		let todayComps = self.calendar.components(units, fromDate: NSDate())
		
		let month = comps.month
		let wday = self.unitWeekdayToRealWeekday(comps.weekday)
		let day = comps.day
		let totalWeeks = self.calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: calcDay)
		let totalDays = self.calendar.rangeOfUnit(.DayCalendarUnit, inUnit: .MonthCalendarUnit, forDate: calcDay)
		let swday = self.calculateStartWeekdayWithCurrentWeekday(wday, andDay: day)
		self.daysOffset = swday - 1
		
		let df = NSDateFormatter()
		df.locale = NSLocale.currentLocale()
		self.monthLabel.textColor = self.monthColor
		self.monthLabel.text = df.standaloneMonthSymbols[month - 1] as? String
		self.prevMonthLabel.textColor = self.monthColor
		self.nextMonthLabel.textColor = self.monthColor
		
		for s in self.weeksView.subviews as [UIView] {
			s.removeFromSuperview()
		}
		
		for i in 0..<totalWeeks.length {
			let weekView = self.generateWeek()
			self.generateDaysForWeek(weekView, baseTag: i * 7)
		}
		
		for i in 1...totalDays.length {
			let dayLabel = (self.weeksView.viewWithTag(self.daysOffset + i) as? TodayDayLabel)!
			dayLabel.text = "\(i)"
		}
		
		if comps == todayComps {
			if let todayView = self.weeksView.viewWithTag(self.daysOffset + day) {
				var hlRect = todayView.bounds
				hlRect = CGRectInset(hlRect, hlRect.size.width * 0.2, hlRect.size.height * 0.1)
				
				let hlView = UIView(frame: hlRect)
				hlView.layer.borderColor = self.todayColor.CGColor
				hlView.layer.borderWidth = 1
				hlView.layer.cornerRadius = 10
				hlView.autoresizingMask = .FlexibleTopMargin | .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
				todayView.addSubview(hlView)
			}
		}
		
		self.requestEventDays()
	}
	
	
	func requestEventDays() {
		let store = EKEventStore()
		
		if EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) == EKAuthorizationStatus.Authorized {
			self.markEventDays(store)
		}
		else {
			store.requestAccessToEntityType(EKEntityTypeEvent, completion: {
				[weak self] (granted: Bool, _) in
				
				if self != nil && granted {
					self!.markEventDays(store)
				}
			})
		}
	}
	
	
	func markEventDays(store: EKEventStore) {
		let cal = NSCalendar.currentCalendar()
		
		let units: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit
		let comps = self.calendar.components(units, fromDate: self.dayToGenerate)
		
		var startComps = comps
		startComps.day = 1
		let startDate = self.calendar.dateFromComponents(startComps)
		
		var endComps = comps
		endComps.day = 0
		endComps.month++;
		let endDate = self.calendar.dateFromComponents(endComps)
		
		let pred = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
		let events = store.eventsMatchingPredicate(pred) as [EKEvent]!
		
		if events != nil {
			for e in events {
				let c = self.calendar.components(units, fromDate: e.startDate)
				if let eventView = self.weeksView.viewWithTag(self.daysOffset + c.day) as? TodayDayLabel {
					eventView.pointColor = self.eventColor
				}
			}
		}
	}
	
	
	func unitWeekdayToRealWeekday(weekday: Int) -> Int {
		let wf = self.calendar.firstWeekday
		let wc = self.calendar.weekdaySymbols.count
		
		var ret = weekday - (wf - 1)
		if ret < 1 {
			ret += wc
		}
		
		return ret
	}
	
	
	func realWeekdayToUnitWeekday(weekday: Int) -> Int {
		let wf = self.calendar.firstWeekday
		let wc = self.calendar.weekdaySymbols.count
		
		var ret = wc - weekday - (wf - 1)
		if ret < 1 {
			ret += wc
		}
		
		return ret
	}
	
	
	func calculateStartWeekdayWithCurrentWeekday(wday: Int, andDay day: Int) -> Int {
		let wc = self.calendar.weekdaySymbols.count
		
		var local_day = day
		var local_wday = wday
		
		while local_day > 1 {
			local_day--
			
			if --local_wday == 0 {
				local_wday = wc
			}
		}
		
		return local_wday
	}
	
	
	@IBAction func doSwitchMonth(rec: UIGestureRecognizer!) {
		let pt = rec.locationInView(rec.view)
		let w = rec.view!.bounds.width
		
		let units: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit
		var comps = self.calendar.components(units, fromDate: self.dayToGenerate)
		
		if pt.x < (w * 0.3) {
			comps.month--
			self.dayToGenerate = self.calendar.dateFromComponents(comps)!
		}
		else if pt.x > (w * 0.7) {
			comps.month++
			self.dayToGenerate = self.calendar.dateFromComponents(comps)!
		}
		else {
			self.dayToGenerate = NSDate()
		}
		
		self.generateCalendar()
	}
}
