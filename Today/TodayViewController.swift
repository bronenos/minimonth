//
//  TodayViewController.swift
//  Today
//
//  Created by Stan Potemkin on 9/12/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController : UIViewController {
	let monthColor = UIColor.whiteColor()
	let dayColor = UIColor.whiteColor()
	let weekendColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
	let todayColor = UIColor.greenColor().colorWithAlphaComponent(0.65).CGColor
	
	
	let lastDatePrefKey = "lastDate"
	
	
	@IBOutlet var _monthLabel: TodayMonthLabel!
	var monthLabel: TodayMonthLabel! { return _monthLabel }
	
	@IBOutlet var _weekdaysView: UIView!
	var weekdaysView: UIView! { return _weekdaysView }
	
	@IBOutlet var _weeksView: UIView!
	var weeksView: UIView! { return _weeksView }
	
	@IBOutlet var _weeksHeightConstraint: NSLayoutConstraint!
	var weeksHeightConstraint: NSLayoutConstraint! { return _weeksHeightConstraint }
	
	
	let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.calendar.firstWeekday = 2
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.generateWeekdayTitles()
		self.generateCalendar()
    }
	
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
		let defs = NSUserDefaults.standardUserDefaults()
		let newDate = self.dateStamp()
		
		if let lastDate = defs.objectForKey(self.lastDatePrefKey) as? String {
			completionHandler(newDate == lastDate ? .NoData : .NewData)
		}
		else {
			completionHandler(NCUpdateResult.NewData)
		}
		
		defs.setObject(newDate, forKey: self.lastDatePrefKey)
		defs.synchronize()
    }
	
	
	func dateStamp() -> String {
		let df = NSDateFormatter()
		df.dateStyle = .ShortStyle
		df.timeStyle = .NoStyle
		return df.stringFromDate(NSDate())
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
	
	
	func generateWeekdayTitles() {
		let df = NSDateFormatter()
		df.calendar = self.calendar
		
		var weekdays = df.shortWeekdaySymbols as [String]
		
		let fwd = df.calendar.firstWeekday
		let wc = weekdays.count
		weekdays = Array(weekdays[(fwd-1)..<wc]) + Array(weekdays[0..<fwd])
		
		for i in 0..<weekdays.count {
			var label = TodayWeekdayLabel(frame: CGRectZero)
			label.text = weekdays[i]
			label.textColor = (i < 5 ? self.dayColor : self.weekendColor).colorWithAlphaComponent(0.6)
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
		let weekView = TodayWeekView()
		self.weeksView.addSubview(weekView)
		
		self.autoLayout(weekView, verticalMode: true)
		
		let c = NSLayoutConstraint(
			item: weekView, attribute: .Height,
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
		
		return weekView
	}
	
	
	func generateWeekdaysForWeek(weekView: UIView, baseTag: Int) {
		for i in 0..<7 {
			let weekdayView = TodayDayLabel()
			weekdayView.tag = baseTag + i + 1
			weekdayView.textColor = (i < 5 ? self.dayColor : self.weekendColor)
			weekView.addSubview(weekdayView)
			
			self.autoLayout(weekdayView, verticalMode: false)
			
			let c = NSLayoutConstraint(
				item: weekdayView, attribute: .Width,
				relatedBy: .Equal,
				toItem: weekdayView.superview, attribute: .Width,
				multiplier: 1.0 / 7.0,
				constant: 0)
			weekView.addConstraint(c)
		}
		
		weekView.updateConstraintsIfNeeded()
		weekView.layoutIfNeeded()
	}
	
	
	func generateCalendar() {
		let today = NSDate()
		
		let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		let units = NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit
		let comps = cal.components(units, fromDate: today)
		
		let month = comps.month
		let wday = self.unitWeekdayToRealWeekday(comps.weekday)
		let day = comps.day
		let totalWeeks = cal.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: today)
		let totalDays = cal.rangeOfUnit(.DayCalendarUnit, inUnit: .MonthCalendarUnit, forDate: today)
		let swday = self.calculateStartWeekdayWithCurrentWeekday(wday, andDay: day)
		
		let df = NSDateFormatter()
		df.locale = NSLocale.currentLocale()
		self.monthLabel.text = df.standaloneMonthSymbols[month - 1] as String
		
		for i in 0..<totalWeeks.length {
			let weekDay = self.generateWeek()
			self.generateWeekdaysForWeek(weekDay, baseTag: i * 7)
		}
		
		for i in 1...totalDays.length {
			let dayLabel = (self.weeksView.viewWithTag(swday - 1 + i) as? TodayDayLabel)!
			dayLabel.text = "\(i)"
		}
		
		if let todayView = self.weeksView.viewWithTag(day) {
			var hlRect = todayView.bounds
			hlRect = CGRectInset(hlRect, hlRect.size.width * 0.25, hlRect.size.height * 0.1)
			hlRect.origin.x *= self.isRunningAsWidget() ? 0.75 : 1.0
			
			let hlView = UIView(frame: hlRect)
			hlView.layer.borderColor = self.todayColor
			hlView.layer.borderWidth = 1
			hlView.layer.cornerRadius = 10
			todayView.addSubview(hlView)
		}
	}
	
	
	func unitWeekdayToRealWeekday(weekday: Int) -> Int {
		let fwd = self.calendar.firstWeekday
		let wc = self.calendar.weekdaySymbols.count
		
		return (weekday > fwd ? weekday : wc) - (fwd - 1)
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
	
	
	func isRunningAsWidget() -> Bool {
		return (self.extensionContext != nil)
	}
	
	
	@IBAction func doOpenCalendar() {
		if self.isRunningAsWidget() {
			let url = NSURL(string: "calshow://")
			self.extensionContext.openURL(url, completionHandler: nil)
		}
	}
}
