//
//  AppViewController.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 10/28/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import Foundation
import UIKit


class AppViewController : UIViewController, ColorViewControllerDelegate {
	@IBOutlet var _calendarPlaceholder: UIView!
	@IBOutlet var _monthColorView: UIView!
	@IBOutlet var _dayColorView: UIView!
	@IBOutlet var _weekendColorView: UIView!
	@IBOutlet var _todayColorView: UIView!
	@IBOutlet var _eventColorView: UIView!
	
	var _calendarController: TodayViewController!
	weak var _activeColorView: UIView!
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.edgesForExtendedLayout = .None
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		TodayViewController.registerDefaultColors()
		let defs = NSUserDefaults(suiteName: "group.me.bronenos.minimonth")!
		let h2c = TodayViewController.hexToColor
		
		_monthColorView.layer.cornerRadius = 12;
		_dayColorView.layer.cornerRadius = 12;
		_weekendColorView.layer.cornerRadius = 12;
		_todayColorView.layer.cornerRadius = 12;
		_eventColorView.layer.cornerRadius = 12;
		
		_monthColorView.backgroundColor = h2c(defs.objectForKey(monthColorPrefKey) as String)
		_dayColorView.backgroundColor = h2c(defs.objectForKey(dayColorPrefKey) as String)
		_weekendColorView.backgroundColor = h2c(defs.objectForKey(weekendColorPrefKey) as String)
		_todayColorView.backgroundColor = h2c(defs.objectForKey(todayColorPrefKey) as String)
		_eventColorView.backgroundColor = h2c(defs.objectForKey(eventColorPrefKey) as String)
		
		self.refreshCalendar()
	}
	
	
	func refreshCalendar() {
		let sb = UIStoryboard(name: "MainInterface", bundle: nil)
		
		if _calendarController != nil {
			_calendarController.view.removeFromSuperview()
			_calendarController = nil
		}
		
		_calendarController = sb.instantiateInitialViewController() as? TodayViewController
		_calendarController.view.frame = _calendarPlaceholder.bounds
		_calendarPlaceholder.addSubview(_calendarController.view)
	}
	
	
	@IBAction func doOpenColorPicker(rec: UIGestureRecognizer) {
		for v in [_monthColorView, _dayColorView, _weekendColorView, _todayColorView, _eventColorView] {
			if CGRectContainsPoint(v.bounds, rec.locationInView(v)) {
				_activeColorView = v
				break
			}
		}
		
		let pickerView = ColorViewController(delegate: self)
		pickerView.color = _activeColorView.backgroundColor
		self.navigationController!.pushViewController(pickerView, animated: true)
	}
	
	
	func colorView(colorView: ColorViewController, didSelectColor color: UIColor) {
		_activeColorView.backgroundColor = color
		
		let defs = NSUserDefaults(suiteName: "group.me.bronenos.minimonth")!
		
		switch _activeColorView {
		case _monthColorView:
			defs.setObject(TodayViewController.colorToHex(color), forKey: monthColorPrefKey)
			
		case _dayColorView:
			defs.setObject(TodayViewController.colorToHex(color), forKey: dayColorPrefKey)
			
		case _weekendColorView:
			defs.setObject(TodayViewController.colorToHex(color), forKey: weekendColorPrefKey)
			
		case _todayColorView:
			defs.setObject(TodayViewController.colorToHex(color), forKey: todayColorPrefKey)
			
		case _eventColorView:
			defs.setObject(TodayViewController.colorToHex(color), forKey: eventColorPrefKey)
			
		default: ()
		}
		
		defs.synchronize()
		
		self.refreshCalendar()
	}
}
