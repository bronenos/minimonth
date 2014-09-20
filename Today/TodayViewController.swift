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
	
	
	let calendar = NSCalendar.currentCalendar()
	let dateFormatter = NSDateFormatter()
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.dateFormatter.calendar = self.calendar
		self.dateFormatter.locale = NSLocale.currentLocale()
		self.dateFormatter.dateStyle = .ShortStyle
		self.dateFormatter.timeStyle = .NoStyle
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
		let defs = NSUserDefaults.standardUserDefaults()
		let newDate = self.dateStamp()
		
		if let lastDate = defs.objectForKey(self.lastDatePrefKey) as? String {
			if newDate == lastDate {
				completionHandler(.NoData)
			}
			else {
				defs.setObject(newDate, forKey: self.lastDatePrefKey)
				defs.synchronize()
				
				completionHandler(.NewData)
			}
		}
		else {
			defs.setObject(newDate, forKey: self.lastDatePrefKey)
			defs.synchronize()
			
			completionHandler(.NewData)
		}
    }
	
	
	func dateStamp() -> String {
		return self.dateFormatter.stringFromDate(NSDate())
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
			label.textColor = (self.realWeekdayToUnitWeekday(i) <= 5 ? self.dayColor : self.weekendColor).colorWithAlphaComponent(0.6)
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
		let today = NSDate()
		
		let units: NSCalendarUnit = .MonthCalendarUnit | .WeekdayCalendarUnit | .DayCalendarUnit
		let comps = self.calendar.components(units, fromDate: today)
		
		let month = comps.month
		let wday = self.unitWeekdayToRealWeekday(comps.weekday)
		let day = comps.day
		let totalWeeks = self.calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: today)
		let totalDays = self.calendar.rangeOfUnit(.DayCalendarUnit, inUnit: .MonthCalendarUnit, forDate: today)
		let swday = self.calculateStartWeekdayWithCurrentWeekday(wday, andDay: day)
		let offset = swday - 1
		
		let df = NSDateFormatter()
		df.locale = NSLocale.currentLocale()
		self.monthLabel.text = df.standaloneMonthSymbols[month - 1] as? String
		
		for i in 0..<totalWeeks.length {
			let weekView = self.generateWeek()
			self.generateDaysForWeek(weekView, baseTag: i * 7)
		}
		
		for i in 1...totalDays.length {
			let dayLabel = (self.weeksView.viewWithTag(offset + i) as? TodayDayLabel)!
			dayLabel.text = "\(i)"
		}
		
		if let todayView = self.weeksView.viewWithTag(offset + day) {
			var hlRect = todayView.bounds
			hlRect = CGRectInset(hlRect, hlRect.size.width * 0.2, hlRect.size.height * 0.1)
			
			let hlView = UIView(frame: hlRect)
			hlView.layer.borderColor = self.todayColor
			hlView.layer.borderWidth = 1
			hlView.layer.cornerRadius = 10
			hlView.autoresizingMask = .FlexibleTopMargin | .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
			todayView.addSubview(hlView)
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
	
	
	@IBAction func doOpenCalendar() {
		let url = NSURL(string: "calshow://")
		self.extensionContext?.openURL(url, completionHandler: nil)
	}
}
