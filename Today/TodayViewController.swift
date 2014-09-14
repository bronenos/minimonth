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
	
	@IBOutlet var _daysView: UIView!
	var daysView: UIView! { return _daysView }
	
	@IBOutlet var _heightConstraint: NSLayoutConstraint!
	var heightConstraint: NSLayoutConstraint! { return _heightConstraint }
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.generateWeekdays()
    }
	
	
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
	
	
	func generateWeekdays() {
		let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
		
		var prevLabel: TodayWeekdayLabel!
		var c: NSLayoutConstraint!
		
		for weekday in weekdays {
			var label = TodayWeekdayLabel(frame: CGRectZero)
			label.text = weekday
			self.weekdaysView.addSubview(label)
			
			c = NSLayoutConstraint(
				item: label,
				attribute: NSLayoutAttribute.Top,
				relatedBy: NSLayoutRelation.Equal,
				toItem: label.superview,
				attribute: NSLayoutAttribute.Top,
				multiplier: 1,
				constant: 0)
			self.weekdaysView.addConstraint(c)
			
			c = NSLayoutConstraint(
				item: label,
				attribute: NSLayoutAttribute.Bottom,
				relatedBy: NSLayoutRelation.Equal,
				toItem: label.superview,
				attribute: NSLayoutAttribute.Bottom,
				multiplier: 1,
				constant: 0)
			self.weekdaysView.addConstraint(c)
			
			c = NSLayoutConstraint(
				item: label,
				attribute: NSLayoutAttribute.Width,
				relatedBy: NSLayoutRelation.Equal,
				toItem: label.superview,
				attribute: NSLayoutAttribute.Width,
				multiplier: 0.1428,
				constant: 0)
			self.weekdaysView.addConstraint(c)
			
			if prevLabel == nil {
				c = NSLayoutConstraint(
					item: label,
					attribute: NSLayoutAttribute.Leading,
					relatedBy: NSLayoutRelation.Equal,
					toItem: label.superview,
					attribute: NSLayoutAttribute.Leading,
					multiplier: 1,
					constant: 0)
				self.weekdaysView.addConstraint(c)
			}
			else {
				c = NSLayoutConstraint(
					item: label,
					attribute: NSLayoutAttribute.Left,
					relatedBy: NSLayoutRelation.Equal,
					toItem: prevLabel,
					attribute: NSLayoutAttribute.Right,
					multiplier: 1,
					constant: 0)
				self.weekdaysView.addConstraint(c)
				
				println(c)
			}
			
			prevLabel = label
		}
		
		self.weekdaysView.updateConstraintsIfNeeded()
		self.weekdaysView.layoutIfNeeded()
	}
    
}
