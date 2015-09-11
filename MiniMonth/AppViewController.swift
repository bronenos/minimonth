//
//  AppViewController.swift
//  MiniMonth
//
//  Created by Stan Potemkin on 10/28/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

import Foundation
import UIKit


class AppViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, ColorViewControllerDelegate {
	@IBOutlet var _backgroundImageView: UIImageView!
	@IBOutlet var _calendarPlaceholder: UIView!
	@IBOutlet var _calendarHeightConstraint: NSLayoutConstraint!
	@IBOutlet var _configPlaceholder: UIView!
	
	var _calendarController: TodayViewController!
	var _tableView: UITableView!
	
	let _configLabels = ["Month", "Day", "Weekend", "Today", "Event"]
	let _configKeys = [monthColorPrefKey, dayColorPrefKey, weekendColorPrefKey, todayColorPrefKey, eventColorPrefKey]
	var _selectedConfig: Int!
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = NSLocalizedString("Preview", comment: "")
		
		TodayViewController.registerDefaultColors()
		
		self.buildCalendar()
		self.buildConfigTable()
	}
	
	
	func buildCalendar() {
		let sb = UIStoryboard(name: "MainInterface", bundle: nil)
		
		if _calendarController != nil {
			_calendarController.view.removeFromSuperview()
			_calendarController = nil
		}
		
		_calendarController = sb.instantiateInitialViewController() as? TodayViewController
		_calendarController.view.frame = _calendarPlaceholder.bounds
		_calendarController.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
		_calendarPlaceholder.addSubview(_calendarController.view)
		
		if UIDevice.currentDevice().model.hasPrefix("iPad") {
			if _calendarHeightConstraint != nil {
				_calendarHeightConstraint.constant += 80;
				_calendarHeightConstraint = nil
			}
		}
		else {
			var tf = CGAffineTransformIdentity
			tf = CGAffineTransformScale(tf, 0.8, 0.8)
			_calendarPlaceholder.layer.anchorPoint = CGPointMake(0.5, 0.6)
			_calendarPlaceholder.transform = tf
		}
	}
	
	
	func buildConfigTable() {
		if _tableView == nil {
			_tableView = UITableView(frame: _configPlaceholder.bounds, style: .Plain)
			_tableView.backgroundColor = UIColor.clearColor()
			_tableView.backgroundView = UIView()
			_tableView.dataSource = self
			_tableView.delegate = self
			_tableView.rowHeight = 39
			_tableView.separatorColor = UIColor.clearColor()
			_tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
			_configPlaceholder.addSubview(_tableView)
		}
		else {
			_tableView.reloadData()
		}
	}
	
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.backgroundColor = UIColor.clearColor()
		label.text = NSLocalizedString("Configure your calendar", comment: "")
		label.textAlignment = .Center
		label.textColor = UIColor.whiteColor()
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
		return label
	}
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _configKeys.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = ConfigCell(configKey: _configKeys[indexPath.row])
		cell.backgroundColor = UIColor.clearColor()
		cell.backgroundView = UIView()
		cell.contentView.backgroundColor = UIColor.clearColor()
		cell.textLabel!.text = NSLocalizedString(_configLabels[indexPath.row], comment: "")
		cell.textLabel!.textColor = UIColor.whiteColor()
		cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: 16)
		cell.accessoryType = .DisclosureIndicator
		cell.selectionStyle = .None
		return cell
	}
	
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		_selectedConfig = indexPath.row
		
		let defs = NSUserDefaults(suiteName: "group.me.bronenos.minimonth")!
		let hex2color = TodayViewController.hexToColor
		
		let pickerView = ColorViewController(delegate: self)
		pickerView.navigationItem.title = NSLocalizedString(_configLabels[_selectedConfig], comment: "")
		pickerView.color = hex2color(defs.objectForKey(_configKeys[_selectedConfig]) as! String)
		
		if UIDevice.currentDevice().model.hasPrefix("iPad") {
			let cell = tableView.cellForRowAtIndexPath(indexPath)!
			let rect = self.view.convertRect(cell.bounds, fromView: cell)
			
			let popover = UIPopoverController(contentViewController: pickerView)
			popover.popoverContentSize = CGSizeMake(320, 480)
			popover.presentPopoverFromRect(rect, inView: self.view, permittedArrowDirections: .Up, animated: true)
			popover.passthroughViews = []
		}
		else {
			self.navigationController!.pushViewController(pickerView, animated: true)
		}
	}
	
	
	func colorView(colorView: ColorViewController, didSelectColor color: UIColor) {
		let configKey = _configKeys[_selectedConfig]
		
		let defs = NSUserDefaults(suiteName: "group.me.bronenos.minimonth")!
		let color2hex = TodayViewController.colorToHex
		
		defs.setObject(color2hex(color), forKey: _configKeys[_selectedConfig])
		defs.synchronize()
		
		self.buildConfigTable()
		self.buildCalendar()
	}
}
