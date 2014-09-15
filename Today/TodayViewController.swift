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
	@IBOutlet var _weekdaysView: UIView!
	var weekdaysView: UIView! { return _weekdaysView }
	
	@IBOutlet var _weeksView: UIView!
	var weeksView: UIView! { return _weeksView }
	
	@IBOutlet var _weeksHeightConstraint: NSLayoutConstraint!
	var weeksHeightConstraint: NSLayoutConstraint! { return _weeksHeightConstraint }
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.generateWeekdayTitles()
		self.generateCalendar()
    }
	
	
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
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
		let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
		
		for weekday in weekdays {
			var prevLabel: TodayWeekdayLabel!
			if let $ = self.weekdaysView.subviews.last as? TodayWeekdayLabel {
				prevLabel = $
			}
			
			var label = TodayWeekdayLabel(frame: CGRectZero)
			label.text = weekday
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
	
	
	func generateWeekdaysForWeek(weekView: UIView) {
		for i in 1...7 {
			let weekdayView = TodayDayLabel()
			weekdayView.tag = i
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
		let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		let units = NSCalendarUnit.WeekdayCalendarUnit | NSCalendarUnit.DayCalendarUnit
		let comps = cal.components(units, fromDate: NSDate())
		
		let wday = self.unitWeekdayToRealWeekday(comps.weekday)
		let day = comps.day
	}
	
	
	func unitWeekdayToRealWeekday(weekday: Int) -> Int {
		return (weekday == 1 ? 7 : weekday - 1)
	}
}
