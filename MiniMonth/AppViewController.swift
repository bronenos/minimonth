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
		super.init(coder: aDecoder)!
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = NSLocalizedString("Preview", comment: "")
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.buildCalendar()
        self.buildConfigTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 10, *) {
            _calendarPlaceholder.frame.size.height = _calendarHeightConstraint.constant
            view.setNeedsLayout()
        }
    }
	
	func buildCalendar() {
		let sb = UIStoryboard(name: "MainInterface", bundle: nil)
		
		if _calendarController != nil {
			_calendarController.view.removeFromSuperview()
			_calendarController = nil
		}
		
		_calendarController = sb.instantiateInitialViewController() as? TodayViewController
		_calendarController.view.frame = _calendarPlaceholder.bounds
		_calendarController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        _calendarPlaceholder.layer.cornerRadius = 12
        _calendarPlaceholder.layer.masksToBounds = true
        
        addChildViewController(_calendarController)
		_calendarPlaceholder.addSubview(_calendarController.view)
		
		if UIDevice.current.model.hasPrefix("iPad") {
			if _calendarHeightConstraint != nil {
				_calendarHeightConstraint.constant += 80;
				_calendarHeightConstraint = nil
			}
		}
		else {
			var tf = CGAffineTransform.identity
			tf = tf.scaledBy(x: 0.8, y: 0.8)
			_calendarPlaceholder.layer.anchorPoint = CGPoint(x: 0.5, y: 0.6)
			_calendarPlaceholder.transform = tf
		}
        
        if #available(iOS 10, *) {
            _calendarPlaceholder.backgroundColor = UIColor(red: 0.72, green: 0.73, blue: 0.78, alpha: 1.0)
        }
	}
	
	
	func buildConfigTable() {
		if _tableView == nil {
			_tableView = UITableView(frame: _configPlaceholder.bounds, style: .plain)
			_tableView.backgroundColor = UIColor.clear
			_tableView.backgroundView = UIView()
			_tableView.dataSource = self
			_tableView.delegate = self
			_tableView.rowHeight = 39
			_tableView.separatorColor = UIColor.clear
			_tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			_configPlaceholder.addSubview(_tableView)
		}
		else {
			_tableView.reloadData()
		}
	}
	
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.backgroundColor = UIColor.clear
		label.text = NSLocalizedString("Configure your calendar", comment: "")
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
		return label
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _configKeys.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = ConfigCell(configKey: _configKeys[indexPath.row])
		cell.backgroundColor = UIColor.clear
		cell.backgroundView = UIView()
		cell.contentView.backgroundColor = UIColor.clear
		cell.textLabel!.text = NSLocalizedString(_configLabels[indexPath.row], comment: "")
		cell.textLabel!.textColor = UIColor.white
		cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: 16)
		cell.accessoryType = .disclosureIndicator
		cell.selectionStyle = .none
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		_selectedConfig = indexPath.row
		
		let defs = UserDefaults(suiteName: "group.me.bronenos.minimonth")!
		let hex2color = TodayViewController.hexToColor
		
		let pickerView = ColorViewController(delegate: self)
		pickerView.navigationItem.title = NSLocalizedString(_configLabels[_selectedConfig], comment: "")
		pickerView.color = hex2color(defs.object(forKey: _configKeys[_selectedConfig]) as! String)
		
		if UIDevice.current.model.hasPrefix("iPad") {
			let cell = tableView.cellForRow(at: indexPath)!
			let rect = self.view.convert(cell.bounds, from: cell)
			
			let popover = UIPopoverController(contentViewController: pickerView)
			popover.contentSize = CGSize(width: 320, height: 480)
			popover.present(from: rect, in: self.view, permittedArrowDirections: .up, animated: true)
			popover.passthroughViews = []
		}
		else {
			self.navigationController!.pushViewController(pickerView, animated: true)
		}
	}
	
	
	func colorView(_ colorView: ColorViewController, didSelectColor color: UIColor) {
		let defs = UserDefaults(suiteName: "group.me.bronenos.minimonth")!
		let color2hex = TodayViewController.colorToHex
		
		defs.set(color2hex(color), forKey: _configKeys[_selectedConfig])
		defs.synchronize()
		
		self.buildConfigTable()
		self.buildCalendar()
	}
}
